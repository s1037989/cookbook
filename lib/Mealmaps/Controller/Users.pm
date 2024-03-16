package Mealmaps::Controller::Users;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Mealmaps::Util;

sub add ($self) {
  $self->render(user => undef);
}

sub auth ($self) {
  return 1 if $self->user->admin;
  $self->render(text => '404', status => 404);
  return undef;
}

sub edit ($self) {
  $self->render(user => $self->users->find($self->param('username')));
}

sub index ($self) {
  $self->render(users => $self->users->all);
}

sub remove ($self) {
  $self->users->remove($self->param('username'));
  $self->redirect_to('users');
}

sub show ($self) {
  $self->render(user => $self->users->find($self->param('username')));
}

sub store ($self) {
  my $v = $self->_validation;
  return $self->render(action => 'add', user => undef) if $v->has_error;

  my $username = $self->users->add($v->output, $v->param('password'));
  $self->redirect_to('show_user', username => $username);
}

sub update ($self) {
  my $v = $self->_validation;
  return $self->render(action => 'edit', user => undef) if $v->has_error;

  my $username = $self->param('username');
  $self->users->save($v->input, $v->output);
  $self->redirect_to('show_user', username => $username);
}

sub _validation ($self) {
  my $v = $self->validation;
  my $user = $self->users->find($self->param('username')) || {};
  $v->input({%$user, $v->input->%*});
  $v->required('username', 'not_empty');
  $v->optional('password', 'not_empty');
  $v->optional('admin',    'not_empty');
  $v->required('email',    'not_empty');
  $v->required('name',     'not_empty');
  return $v;
}

1;