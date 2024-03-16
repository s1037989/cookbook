package Mealmaps::Controller::Admin;
use Mojo::Base 'Mojolicious::Controller', -signatures;

has username => sub { shift->session('user.username') };
has admin => sub { shift->stash_session('user.admin') };

sub auth ($self) {
  return 1 if $self->username && $self->admin;
  # $self->render(text => '404', status => 404);
  $self->reply->not_found;
  return undef;
}

1;
