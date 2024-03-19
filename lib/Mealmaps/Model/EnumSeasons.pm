package Mealmaps::Model::EnumSeasons;
use Mojo::Base 'Mealmaps::Model::_Enum', -signatures;

has fields => sub { [qw(season name seq)] };
has id => 'season';
has table => 'enum_seasons';

1;