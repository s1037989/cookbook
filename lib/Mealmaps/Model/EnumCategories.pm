package Mealmaps::Model::EnumCategories;
use Mojo::Base 'Mealmaps::Model::_Enum', -signatures;

has fields => sub { [qw(category name seq)] };
has id => 'category';
has table => 'enum_categories';

1;