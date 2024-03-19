package Mealmaps::Model::EnumDietaryRestrictions;
use Mojo::Base 'Mealmaps::Model::_Enum', -signatures;

has fields => sub { [qw(restriction name seq)] };
has id => 'restriction';
has table => 'enum_dietary_restrictions';

1;
