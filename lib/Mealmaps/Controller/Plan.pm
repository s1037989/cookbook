package Mealmaps::Controller::Plan;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Mojo::Util qw(b64_encode);

sub add ($self) {
  my $id = $self->param('id');
  my $meal_options = $self->config->{meal_options};
  my $meal = $self->recipes->find($id)->{meal};
  $self->session->{plan}->{$meal} ||= [];
  push @{$self->session->{plan}->{$meal}}, $id unless scalar @{$self->session->{plan}->{$meal}} > $meal_options || grep { $_ == $id } @{$self->session->{plan}->{$meal}};
  $self->redirect_to('meal_recipes', meal => lc($meal));
}

sub empty ($self) {
  my $meal = $self->param('meal');
  delete $self->session->{plan};
  $self->redirect_to('meal_recipes', meal => lc($meal));
}

sub generate ($self) {
  $self->render(inline => '%= dumper $plan', plan => $self->session('plan'));
}

sub remove ($self) {
  my $id = $self->param('id');
  my $meal = $self->recipes->find($id)->{meal};
  $self->session->{plan}->{$meal} ||= [];
  $self->session->{plan}->{$meal} = [grep { $_ != $id } @{$self->session->{plan}->{$meal}}];
  $self->redirect_to('meal_recipes', meal => lc($meal));
}

sub view ($self) {
  $self->render(plan => $self->session('plan'));
}

1;
