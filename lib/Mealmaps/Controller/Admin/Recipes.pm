package Mealmaps::Controller::Admin::Recipes;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Mealmaps::Util qw(fraction);
use Mojo::Util qw(b64_encode);

sub create { shift->render(recipe => {}) }

sub edit ($self) {
  $self->render(recipe => $self->recipes->find($self->param('id')));
}

sub index ($self) {
  my $meal = $self->param('meal');
  $self->render(meal => $meal, recipes => $self->recipes->all($meal));
}

sub remove ($self) {
  $self->recipes->remove($self->param('id'));
  $self->redirect_to('recipes');
}

sub rotate ($self) {
  $self->recipes->rotate;
  $self->redirect_to('recipes');
}

sub show {
  my $self = shift;
  $self->render(recipe => $self->recipes->find($self->param('id')));
}

sub store ($self) {
  my $v = $self->_validation;
  return $self->render(action => 'create', recipe => {}) if $v->has_error;

  # Store recipe
  my $title = $v->output->{title};
  my $id = $self->recipes->add($title, $self->_enum($v->output), $self->_ingredients($v->output));
  return $self->render(action => 'create', db_error => $@, recipe => {}) if $@;
  $self->_store_attachments($v, $id);

  $self->flash(db_insert => 1)->redirect_to('edit_recipe', id => $id);
}

sub update ($self) {
  my $v = $self->_validation;
  return $self->render(action => 'edit', recipe => {}) if $v->has_error;

  # Update recipe
  my $title = $v->output->{title};
  my $id = $self->recipes->save($self->param('id'), $title, $self->_enum($v->output), $self->_ingredients($v->output));
  return $self->render(action => 'edit', db_error => $@, recipe => {}) if $@;
  $self->_store_attachments($v, $id);

  $self->flash(db_update => 1)->redirect_to('edit_recipe', id => $id);
}

sub _store_attachments ($self, $hash, $id) {
  my $img = $hash->{image};
  $img->move_to($self->app->home->child('public', 'recipes')->make_path->child("$id.png")) if $img;
  my $pdf1 = $hash->{original_pdf};
  $pdf1->move_to($self->app->home->child('public', 'recipes')->make_path->child("$id.pdf")) if $pdf1;
  my $pdf2 = $hash->{modified_pdf};
  $pdf2->move_to($self->app->home->child('public', 'recipes')->make_path->child("$id-modified.pdf")) if $pdf2;
}

sub _enum ($self, $hash) {
  my $enum = [];
  foreach (keys %$hash) {
    my ($table, $key) = split /__/, $_, 2;
    next unless $self->app->renderer->get_helper("enum.$table");
    push @$enum, [$table, $self->enum->$table->id, $key, $hash->{$_}];
  }
  return $enum;
}

sub _ingredients ($self, $hash) {
  my $ingredients = {};
  foreach (sort keys %$hash) {
    my ($table, $key) = split /__/, $_, 2;
    next unless $table =~ /^ingredient(\d+)/;
    $ingredients->{$1}->{$key} = $hash->{$_};
  }
  return $ingredients;
}

sub _validation ($self) {
  my $v = $self->validation;

  $v->required('title', 'not_empty');
  $v->optional('image')->upload;
  $v->optional('original_pdf')->upload;
  $v->optional('modified_pdf')->upload;

  _v_checked($v, 'categories', 1, 1);
  _v_checked($v, 'servings', 1, 1);
  _v_checked($v, 'exp_levels', 1, 1);
  _v_checked($v, 'max_prep_times', 1, 1);
  _v_checked($v, 'meals', 1);
  _v_checked($v, 'seasons', 1);
  _v_checked($v, 'allergies', 0);
  _v_checked($v, 'religious_practices', 0);
  _v_checked($v, 'dietary_restrictions', 0);
  _v_checked($v, 'food_dislikes', 0);
  _v_checked($v, 'optional_food_dislikes', 0);
  _v_checked($v, 'food_fears', 0);
  _v_ingredients($v);

  return $v if $v->has_error;

  $self->enum->ingredients->add(map { $v->output->{$_} } grep { /^ingredient(\d+)__name$/ } keys %{$v->output});

  return $v;
}

sub _v_checked ($v, $name, $min=1, $max=0) {
  my $input = $v->input;
  my @checked = grep { /^${name}__/ && $input->{$_} } keys %$input;
  my $checked = scalar @checked;
  return $v->error($name => ["checked_$name", $checked, $min, $max]) unless $checked >= $min && (!$max || $checked <= $max);
  $v->output->{$_} = $input->{$_} for @checked;
  return $v;
}

sub _v_ingredients ($v) {
  my $input = _ingredients(undef, $v->input);
  my $output = {};
  foreach my $n (keys %$input) {
    my ($qty, $unit, $name, $dept) = @{$input->{$n}}{qw(quantity unit name department)};
    next unless $qty || $unit || $name || $dept;
    $qty =~ s/-/ /;
    $v->error(ingredients => ['ingredient_incomplete']) and next unless $qty && $unit && $name && $dept;
    $v->error(ingredients => ['ingredient_quantity']) and next unless fraction($qty);
    $output->{"ingredient${n}__quantity"} = $qty;
    $output->{"ingredient${n}__unit"} = $unit;
    $output->{"ingredient${n}__name"} = $name;
    $output->{"ingredient${n}__department"} = $dept;
  }
  return $v->error(ingredients => ['ingredients']) unless keys %$output >= 1;
  $v->output->{$_} = $output->{$_} for keys %$output;
  return $v;
}

1;
