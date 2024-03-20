package Mealmaps::Controller::Admin::Enum;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Mojo::Util qw(slugify);

sub create { shift->render(record => {}) }

sub edit ($self) {
  my $enum = $self->param('enum');
  my $pk = $self->enum->$enum->id;
  $self->render(enum => $enum, pk => $pk, record => $self->enum->$enum->find_id($self->param('id')));
}

sub index ($self) {
  my $enum = $self->param('enum');
  return $self->redirect_to('manage_enum', enum => $enum) if $enum;
  my $helpers = [sort map { s/^enum\.//; $_ } grep { /^enum/ } keys $self->app->renderer->helpers->%*];
  $self->render(enum => $enum, helpers => $helpers);
}

sub manage ($self) {
  my $enum = $self->param('enum');
  my $pk = $self->enum->$enum->id;
  $self->render(enum => $enum, pk => $pk, records => $self->enum->$enum->all);
}

sub remove ($self) {
  my $enum = $self->param('enum');
  $self->enum->$enum->remove_id($self->param('id'));
  $self->redirect_to('manage_enum');
}

sub show ($self) {
  my $enum = $self->param('enum');
  my $pk = $self->enum->$enum->id;
  $self->render(enum => $enum, pk => $pk, record => $self->enum->$enum->find_id($self->param('id')));
}

sub store ($self) {
  my $v = $self->_validation;
  my $enum = $self->param('enum');
  my $pk = $self->enum->$enum->id;
  return $self->render(action => 'create', enum => $enum, pk => $pk, record => {}) if $v->has_error;

  # Store record
  my $id = slugify($v->param('name'));
  $self->enum->$enum->add($id, $v->param('name'), $v->param('seq'));
  return $self->render(action => 'create', enum => $enum, db_error => $@, record => {}) if $@;

  $self->flash(db_insert => 1)->redirect_to('edit_enum', id => $id);
}

sub update ($self) {
  my $v = $self->_validation;
  my $enum = $self->param('enum');
  my $pk = $self->enum->$enum->id;
  return $self->render(action => 'create', enum => $enum, pk => $pk, record => {}) if $v->has_error;

  # Store record
  my $result = $self->enum->$enum->save($self->param('id'), $v->param('name'), $v->param('seq'));
  return $self->render(action => 'create', enum => $enum, db_error => $@, record => {}) if $@;

  $self->flash(db_update => 1)->redirect_to('edit_enum', id => $self->param('id'));
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

sub _validation ($self) {
  my $v = $self->validation;

  my $enum = $self->param('enum');
  $v->required('name', 'not_empty');
  $v->required('seq', 'not_empty')->num;

  return $v;
}

1;
