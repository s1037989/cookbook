package Mealmaps::Model::Recipes;
use Mojo::Base -base, -signatures;

has 'config';
has 'sqlite';

my @enum = (
  [qw(allergies             allergy)],
  [qw(meals                 meal)],
  [qw(seasons               season)],
  [qw(religious_practices   practice)],
  [qw(dietary_restrictions  restriction)],
  [qw(food_dislikes         food)],
  [qw(food_fears            food)],
  # [qw(units                 unit)],
  [qw(categories            category)],
  [qw(servings              servings)],
  [qw(exp_levels            exp_level)],
  [qw(max_prep_times        max_prep_time)],
  # [qw(source_types          source_type)],
  # [qw(grocery_departments   department)],
);

sub add ($self, $title, $enum, $ingredients) {
  # warn Mojo::Util::dumper($enum);
  my $db = $self->sqlite->db;
  my $id;
  eval {
    my $tx = $db->begin;
    $id = $db->insert('recipes', {title => $title})->last_insert_id;
    foreach (@$enum) {
      my ($table, $column, $key, $value) = @$_;
      $db->insert("recipe_$table", {recipe_id => $id, $column => $key});
    }
    foreach (sort {$a<=>$b} keys %$ingredients) {
      $ingredients->{$_}->{ingredient} = delete $ingredients->{$_}->{name};
      $db->insert("recipe_ingredients", {recipe_id => $id, $ingredients->{$_}->%*});
    }
    $tx->commit;
  };
  return $id unless $@;
}

sub all ($self, $meal=undef) {
  # $self->sqlite->db->select('recipes', undef, {active => {'!=' => undef}, meal => $meal})->hashes;
  $self->sqlite->db->select('recipes')->hashes;
}

sub find ($self, $id) {
  my $c = Mojo::Collection->new;
  my $db = $self->sqlite->db;
  push @$c, $db->select('recipes', undef, {id => $id})->hash;
  foreach (@enum) {
    my ($table, $column) = @$_;
    push @$c, $db->select("recipe_$table", [$column], {recipe_id => $id})->arrays->map(sub { {"${table}__$_->[0]" => 1} })->to_array;
  }
  my $n = 0;
  push @$c, $db->select('recipe_ingredients', [qw(quantity unit ingredient department)], {recipe_id => $id})->hashes->map(sub {
    my $hash = $_;
    $n++;
    $hash->{name} = delete $hash->{ingredient};
    $hash = {map { ("ingredient${n}__$_" => $hash->{$_}) } keys %$hash};
    return $hash;
  })->to_array;
  return {map { %$_ } @{$c->flatten}};
}

sub remove ($self, $id) {
  $self->sqlite->db->delete('recipes', {id => $id});
}

sub rotate ($self, $recipes=2) {
  $self->sqlite->db->update('recipes', {active => 0});
  foreach my $meal (@{$self->config->{meals}}) {
    $self->sqlite->db->query('UPDATE recipes SET active = date(\'now\') WHERE recipes.id IN (SELECT id FROM recipes WHERE meal = ? ORDER BY RANDOM() LIMIT ?)', $meal, $recipes);
  }
}

sub save ($self, $id, $title, $enum, $ingredients) {
  # warn Mojo::Util::dumper($enum);
  my $db = $self->sqlite->db;
  eval {
    my $tx = $db->begin;
    $db->update('recipes', {title => $title}, {id => $id});
    $db->delete("recipe_$_", {recipe_id => $id}) for map { $_->[0] } @enum;
    $db->delete('recipe_ingredients', {recipe_id => $id});
    foreach (@$enum) {
      my ($table, $column, $key, $value) = @$_;
      $db->insert("recipe_$table", {recipe_id => $id, $column => $key});
    }
    foreach (sort {$a<=>$b} keys %$ingredients) {
      $ingredients->{$_}->{ingredient} = delete $ingredients->{$_}->{name};
      $db->insert("recipe_ingredients", {recipe_id => $id, $ingredients->{$_}->%*});
    }
    $tx->commit;
  };
  return $id unless $@;
}

1;
