package Cookbook::Controller::Admin;
use Mojo::Base 'Mojolicious::Controller';

sub auth {
  my $self = shift;
  warn $self->param('admin');
  $self->session(admin => 1) and return 1 if $self->session('admin') || $self->param('admin') eq 'mojolicious';
  $self->reply->not_found;
  return undef;
}

1;
