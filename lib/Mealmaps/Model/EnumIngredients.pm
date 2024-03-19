package Mealmaps::Model::EnumIngredients;
use Mojo::Base 'Mealmaps::Model::_Enum', -signatures;

has fields => sub { [qw(name)] };
has id => 'name';
has table => 'enum_ingredients';

sub add ($self, @ingredients) {
  my $db = $self->sqlite->db;
  eval {
    my $tx = $db->begin;
    $db->insert('enum_ingredients', {name => lc $_}, {on_conflict => undef}) for @ingredients;
    $tx->commit;
  };
}

1;