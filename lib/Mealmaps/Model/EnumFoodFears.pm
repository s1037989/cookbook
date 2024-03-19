package Mealmaps::Model::EnumFoodFears;
use Mojo::Base 'Mealmaps::Model::_Enum', -signatures;

has fields => sub { [qw(food name seq)] };
has id => 'food';
has table => 'enum_food_fears';

1;