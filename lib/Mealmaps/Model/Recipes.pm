package Mealmaps::Model::Recipes;
use Mojo::Base -base, -signatures;

has 'config';
has 'sqlite';

sub add ($self, $recipe) {
  return $self->sqlite->db->insert('recipes', $recipe)->last_insert_id;
}

sub all ($self, $meal=undef) {
  # $self->sqlite->db->select('recipes', undef, {active => {'!=' => undef}, meal => $meal})->hashes;
  $self->sqlite->db->select('recipes')->hashes;
}

sub find ($self, $id) {
  return $self->sqlite->db->select('recipes', undef, {id => $id})->hash;
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

sub save ($self, $id, $recipe) {
  $self->sqlite->db->update('recipes', $recipe, {id => $id});
}

1;
