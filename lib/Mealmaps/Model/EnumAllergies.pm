package Mealmaps::Model::EnumAllergies;
use Mojo::Base 'Mealmaps::Model::_Enum', -signatures;

has fields => sub { [qw(allergy name seq)] };
has id => 'allergy';
has table => 'enum_allergies';

1;
