package Mealmaps::Model::EnumServings;
use Mojo::Base 'Mealmaps::Model::_Enum', -signatures;

has fields => sub { [qw(servings name seq)] };
has id => 'servings';
has table => 'enum_servings';

1;