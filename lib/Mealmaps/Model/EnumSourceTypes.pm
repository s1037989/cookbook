package Mealmaps::Model::EnumSourceTypes;
use Mojo::Base 'Mealmaps::Model::_Enum', -signatures;

has fields => sub { [qw(source_type name seq)] };
has id => 'source_type';
has table => 'enum_source_types';

1;