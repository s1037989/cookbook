package Mealmaps::Model::EnumMaxPrepTimes;
use Mojo::Base 'Mealmaps::Model::_Enum', -signatures;

has fields => sub { [qw(max_prep_time name seq)] };
has id => 'max_prep_time';
has table => 'enum_max_prep_times';

1;