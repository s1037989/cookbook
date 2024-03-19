package Mealmaps::Model::EnumUnits;
use Mojo::Base 'Mealmaps::Model::_Enum', -signatures;

has fields => sub { [qw(unit name seq)] };
has id => 'unit';
has table => 'enum_units';

1;
