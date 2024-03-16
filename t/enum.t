use Mojo::Base -strict;

use Mojo::File qw(curfile);
use Test::More;
use Test::Mojo;
use lib curfile->dirname->sibling('lib')->to_string;

# Override configuration for testing
my $t = Test::Mojo->new(Mealmaps => {sqlite => ':temp:', secrets => ['test_s3cret']});

my @enum = (
  [qw(allergies             allergy      gluten     Gluten     dairy      Dairy)],
  [qw(meals                 meal         breakfast  Breakfast  lunch      Lunch)],
  [qw(seasons               season       spring     Spring     summer     Summer)],
  [qw(religious_practices   practice     kosher     Kosher     no_beef    No_Beef)],
  [qw(dietary_restrictions  restriction  vegetarian Vegetarian vegan      Vegan)],
  [qw(food_dislikes         food         onions     Onions     mushrooms  Mushrooms)],
  [qw(food_fears            food         casseroles Casseroles soups      Soups)],
  [qw(units                 unit         cup        Cup        tablespoon Tablespoon)],
);
foreach (@enum) {
  my ($table, $column, $id1, $name1, $id2, $name2) = @$_;
  $name1 =~ s/_/ /g;
  $name2 =~ s/_/ /g;
  is_deeply $t->app->enum->$table->find_id($id1), {$column => $id1, name => $name1, seq => 1}, "found $id1 $column";
  is_deeply $t->app->enum->$table->find_id($id1), {$column => $id1, name => $name1, seq => 1}, "found $id1 $column";
  is_deeply $t->app->enum->$table->find_name($name1), {$column => $id1, name => $name1, seq => 1}, "found $id1 name";
  is_deeply $t->app->enum->$table->find_name($name1), {$column => $id1, name => $name1, seq => 1}, "found $id1 name";

  is_deeply $t->app->enum->$table->find_id($id2), {$column => $id2, name => $name2, seq => 2}, "$id2 is seq 2";
  eval {
    is $t->app->enum->$table->add($id2, $name2, 2), undef, "failed to add existing $column";
  };
  like $t->app->enum->$table->add("${id2}e", "${name2}e", 2), qr/\d/, "add ${id2}e $column";
  is_deeply $t->app->enum->$table->find_id($id2), {$column => $id2, name => $name2, seq => 3}, "$id2 is seq 3";
  is_deeply $t->app->enum->$table->find_id("${id2}e"), {$column => "${id2}e", name => "${name2}e", seq => 2}, "${id2}e is seq 2";
}

done_testing();
