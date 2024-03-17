package Mealmaps::Model::EnumSourceTypes;
use Mojo::Base -base, -signatures;

use constant TABLE => 'enum_source_types';
use constant FIELDS => [qw(source_type name seq)];
use constant ID => 'source_type';
use constant MAX_SEQ => 1000;

has 'config';
has 'sqlite';

sub add ($self, $id, $name, $seq) {
  my $num = $self->sqlite->db->insert(TABLE, {ID() => $id, name => $name, seq => $seq})->last_insert_id;
  $self->resequence($id, $seq);
  return $num;
}

sub all ($self) {
  $self->sqlite->db->select(TABLE, FIELDS)->hashes;
}

sub find_id ($self, $id) {
  return $self->sqlite->db->select(TABLE, FIELDS, {ID() => $id})->hash;
}

sub find_name ($self, $name) {
  return $self->sqlite->db->select(TABLE, FIELDS, {name => $name})->hash;
}

sub remove_id ($self, $id) {
  $self->sqlite->db->delete(TABLE, {ID() => $id});
}

sub resequence ($self, $id, $seq) {
  my $TABLE = TABLE;
  my $ID = ID;
  $self->sqlite->db->query(qq(
    update $TABLE set seq=seq+1 where $ID in (select $ID from $TABLE where $ID != ? and seq >= ? and seq < ? order by seq desc)
  ), $id, $seq, MAX_SEQ);
}

sub save ($self, $id, $name, $seq) {
  my $update = $self->sqlite->db->update(TABLE, {name => $name, seq => $seq}, {ID() => $id})->hash;
  $self->resequence($id, $seq);
  return $update;
}

1;
