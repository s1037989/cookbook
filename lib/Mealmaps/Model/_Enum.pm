package Mealmaps::Model::_Enum;
use Mojo::Base -base, -signatures;

has 'config';
has fields => sub { die };
has id => sub { die };
has max_seq => 1000;
has 'sqlite';
has table => sub { die };

sub add ($self, $id, $name, $seq) {
  my $num = $self->sqlite->db->insert($self->table, {$self->id => $id, name => $name, seq => $seq})->last_insert_id;
  $self->resequence($id, $seq);
  return $num;
}

sub all ($self) {
  $self->sqlite->db->select($self->table, $self->fields)->hashes
    ->sort(sub { $a->{seq} <=> $b->{seq} || $a->{name} cmp $b->{name} });
}

sub find_id ($self, $id) {
  return $self->sqlite->db->select($self->table, $self->fields, {$self->id => $id})->hash;
}

sub find_name ($self, $name) {
  return $self->sqlite->db->select($self->table, $self->fields, {name => $name})->hash;
}

sub remove_id ($self, $id) {
  $self->sqlite->db->delete($self->table, {$self->id => $id});
}

sub resequence ($self, $id, $seq) {
  my $TABLE = $self->table;
  my $ID = $self->id;
  $self->sqlite->db->query(qq(
    update $TABLE set seq=seq+1 where $ID in (select $ID from $TABLE where $ID != ? and seq >= ? and seq < ? order by seq desc)
  ), $id, $seq, $self->max_seq);
}

sub save ($self, $id, $name, $seq) {
  my $update = $self->sqlite->db->update($self->table, {name => $name, seq => $seq}, {$self->id => $id})->hash;
  $self->resequence($id, $seq);
  return $update;
}

1;
