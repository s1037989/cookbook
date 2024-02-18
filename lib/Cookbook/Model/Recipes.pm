package Cookbook::Model::Recipes;
use Mojo::Base -base, -signatures;

has 'config';
has 'sqlite';

sub add {
  my ($self, $recipe) = @_;
  return $self->sqlite->db->insert('recipes', $recipe)->last_insert_id;
}

sub all ($self, $meal=undef) {
  $self->sqlite->db->select('recipes', undef, {active => 1, meal => $meal})->hashes
}

sub find {
  my ($self, $id) = @_;
  return $self->sqlite->db->select('recipes', undef, {id => $id})->hash;
}

sub remove {
  my ($self, $id) = @_;
  $self->sqlite->db->delete('recipes', {id => $id});
}

sub rotate {
  my $self = shift;
  $self->sqlite->db->update('recipes', {active => 0});
  foreach my $meal (@{$self->config->{meals}}) {
    $self->sqlite->db->query('UPDATE recipes SET active = 1 WHERE recipes.id IN (SELECT id FROM recipes WHERE meal = ? ORDER BY RANDOM() LIMIT 2)', $meal);
  }
}

sub save {
  my ($self, $id, $recipe) = @_;
  $self->sqlite->db->update('recipes', $recipe, {id => $id});
}

1;
