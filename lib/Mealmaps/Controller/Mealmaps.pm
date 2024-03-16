package Mealmaps::Controller::Mealmaps;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Mealmaps::Util;

has default_redirect => 'home';
has username => sub { shift->session('user.username') };

sub auth ($self) {
  return $self->_load_stash if $self->username;
  $self->redirect_to('login');  # TODO: retain POST submission if submitted after timeout
  return undef;
}

sub color ($self) { $self->session(color => $self->param('color'))->redirect_to('home') }

sub load_stash ($self) {
  if (my $jwt = $self->param('jwt') || $self->req->headers->header('X-JWT')) {
    $self->session($self->jwt->decode($jwt)) if $jwt;
    $self->redirect_to($self->req->url->query({jwt => undef})) if $self->param('jwt');
  }
  return $self->_load_stash if $self->username;
  return 1;
}

sub logout { shift->session(expires => 1)->redirect_to('login') }

sub stats ($self) { $self->render(json => $self->app->stats) }

sub process_login ($self) {
  my $user = $self->users->auth($self->param('username'), $self->param('password'));
  # warn Mojo::Util::dumper($user);
  return $self->flash(error => 'login error')->redirect_to('login') unless $user;
  $self->session(_sessionize(user => $user))->redirect_to($self->flash('url') || $self->default_redirect);
}

sub _load_stash ($self) {
  my $user = $self->users->find($self->username) or return undef;
  # warn Mojo::Util::dumper($user);
  $self->stash->{session} = {_sessionize(user => $user)};
}

sub _sessionize ($key, $hash) { map { +"$key.$_" => $hash->{$_} } keys %$hash }

1;
