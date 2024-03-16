package Mealmaps::Controller::Registration;
use Mojo::Base 'Mojolicious::Controller', -signatures;

has username => sub { shift->session('user.username') };

sub auth ($self) {
  return 1 if $self->username;
  $self->render(text => '404', status => 404);
  return undef;
}

sub edit ($self) {
  $self->render(user => $self->users->find($self->username));
}

sub show ($self) {
  $self->render(user => $self->users->find($self->username));
}

sub update ($self) {
  my $v = $self->_validation;
  return $self->render(action => 'edit', user => {}) if $v->has_error;

  my $user_id = $self->user;
  $self->users->save($v->input, $v->output);
  $self->redirect_to('show_profile');
}

sub _validation ($self) {
  my $v = $self->validation;
  my $user = $self->users->find($self->username) || {};
  $v->input({%$user, $v->input->%*});
  $v->optional('password', 'not_empty');
  $v->required('email',    'not_empty');
  $v->required('name',     'not_empty');
  return $v;
}

1;