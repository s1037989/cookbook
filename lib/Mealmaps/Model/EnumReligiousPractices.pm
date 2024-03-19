package Mealmaps::Model::EnumReligiousPractices;
use Mojo::Base 'Mealmaps::Model::_Enum', -signatures;

has fields => sub { [qw(practice name seq)] };
has id => 'practice';
has table => 'enum_religious_practices';

1;