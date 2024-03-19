package Mealmaps::Model::EnumExpLevels;
use Mojo::Base 'Mealmaps::Model::_Enum', -signatures;

has fields => sub { [qw(exp_level name seq)] };
has id => 'exp_level';
has table => 'enum_exp_levels';

1;