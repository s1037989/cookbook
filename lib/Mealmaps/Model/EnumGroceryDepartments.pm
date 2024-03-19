package Mealmaps::Model::EnumGroceryDepartments;
use Mojo::Base 'Mealmaps::Model::_Enum', -signatures;

has fields => sub { [qw(department name seq)] };
has id => 'department';
has table => 'enum_grocery_departments';

1;