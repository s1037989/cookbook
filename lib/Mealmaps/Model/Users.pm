package Mealmaps::Model::Users;
use Mojo::Base -base, -signatures;

has 'config';
has fields => sub { [qw(admin username email name birthday)] };
has 'sqlite';

sub activate ($self, $username, $active=1) {
  $self->sqlite->db->update('users', {active => $active}, {username => $username});
}

sub add ($self, $user) {
  return $self->sqlite->db->insert('users', $user)->last_insert_id;
}

sub all ($self) {
  $self->sqlite->db->select('users', $self->fields, {active => 1})->hashes;
}

sub auth ($self, $username, $password) {
  warn "SELECT username FROM users WHERE active = 1 AND username = $username AND password = $password\n";
  return $self->sqlite->db->select('users', ['username'], {active => 1, username => $username, password => $password})->hash;
}

sub find ($self, $username) {
  return $self->sqlite->db->select('users', $self->fields, {active => 1, username => $username})->hash;
}

sub remove ($self, $username) {
  $self->sqlite->db->delete('users', {username => $username});
}

sub save ($self, $username, $user) {
  $self->sqlite->db->update('users', $user, {username => $username});
}

1;
