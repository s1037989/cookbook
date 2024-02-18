package Cookbook;
use Mojo::Base 'Mojolicious', -signatures;

use Cookbook::Model::Recipes;
use Mojo::SQLite;

sub startup {
  my $self = shift;

  # Configuration
  my $config = $self->plugin('Config' => {default => {meals => [qw(breakfast lunch dinner)]}});
  my $secrets = $config->{secrets};
  $self->secrets($self->config('secrets'));

  # Model
  $self->helper(sqlite => sub { state $sql = Mojo::SQLite->new->from_filename(shift->config('sqlite')) });
  $self->helper(
    recipes => sub { state $recipes = Cookbook::Model::Recipes->new(sqlite => shift->sqlite, config => $config) });

  # Migrate to latest version if necessary
  my $path = $self->home->child('migrations', 'cookbook.sql');
  $self->sqlite->auto_migrate(1)->migrations->name('cookbook')->from_file($path);

  # Controller
  my $r = $self->routes;
  $r->get('/' => sub { shift->redirect_to('recipes') });
  $r->get('/logout' => sub { shift->session(expires => 1)->redirect_to('recipes') });
  $r->get('/recipes')->to('recipes#index');
  $r->get('/recipes/:id')->to('recipes#show')->name('show_recipe');
  $r->get("/admin/$secrets->[0]" => sub { shift->session(admin => 1)->redirect_to('recipes') });
  my $admin = $r->under('/admin')->to('admin#auth');
  $admin->get('/recipes/rotate')->to('recipes#rotate')->name('rotate_recipes');
  $admin->get('/recipes/create')->to('recipes#create')->name('create_recipe');
  $admin->post('/recipes')->to('recipes#store')->name('store_recipe');
  $admin->get('/recipes/:id/edit')->to('recipes#edit')->name('edit_recipe');
  $admin->put('/recipes/:id')->to('recipes#update')->name('update_recipe');
  $admin->delete('/recipes/:id')->to('recipes#remove')->name('remove_recipe');
}

1;
