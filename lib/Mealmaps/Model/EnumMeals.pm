package Mealmaps::Model::EnumMeals;
use Mojo::Base 'Mealmaps::Model::_Enum', -signatures;

has fields => sub { [qw(meal name seq)] };
has id => 'meal';
has table => 'enum_meals';

1;