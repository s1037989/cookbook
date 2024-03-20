package Mealmaps;
use Mojo::Base 'Mojolicious', -signatures;

use Mealmaps::Util qw(usd);
use Mojo::Loader qw(find_modules load_classes);
use Mojo::SQLite;
use Mojo::Util qw(decamelize);

load_classes 'Mealmaps::Model';

sub startup {
  my $self = shift;

  # Configuration
  my $config = $self->plugin('Config' => {default => {
    meal_options => 3,
  }});
  my $secrets = $config->{secrets};
  $self->secrets($self->config('secrets'));
  $self->sessions->default_expiration(86400 * 7);

  $self->helper(stash_session => sub { shift->stash('session', @_) });
  $self->helper(current_section => sub ($c, $name=undef) {
    return unless my $section = $c->stash('section');
    return $name eq $section if $name;
    return $section;
  });
  $self->helper(currency => sub ($c, $value) { usd($value) });

  $self->app->validator->add_check(checked => sub ($v, $name, $value, $min=1, $max=undef) {
    my $input = $v->input;
    my $checked = grep { /^{$name}__/ && $input->{$input} } keys %$input;
    warn "Checked $name: $checked";
    return $checked >= $min && (!$max || $checked <= $max);
  });

  # Model
  $self->helper(sqlite => sub { state $sql = Mojo::SQLite->new->from_filename(shift->config('sqlite')) });
  foreach my $module (grep { /::[A-Z]+$/i } find_modules 'Mealmaps::Model') {
    # e.g. Mealmaps::Model::EnumSeasons -> enum.seasons
    # e.g. Mealmaps::Model::Users       -> users
    my $name = decamelize($module =~ s/^Mealmaps::Model:://r);
    $name =~ s/_/./;
    $self->helper($name => sub { state $model = $module->new(sqlite => shift->sqlite, config => $config) });
  }

  # Migrate to latest version if necessary
  my $path = $self->home->child('migrations', 'mealmaps.sql');
  $self->sqlite->auto_migrate(1)->migrations->name('mealmaps')->from_file($path);

  my $meals = $self->enum->meals->all->map(sub { $_->{name} })->to_array;

  # Controller
  my $r = $self->routes;

  my $mm = $r->under('/' => {section => 'home'})->to('mealmaps#load_stash');
  $mm->get('/')->to('mealmaps#home', template => 'mealmaps/home')->name('home');
  $mm->get('/logout')->to('mealmaps#logout')->name('logout');
  $mm->get('/login')->to('mealmaps#login')->name('login');
  $mm->post('/login')->to('mealmaps#process_login')->name('process_login');

  my $registration = $mm->under('/registration' => {section => 'registration'})->to('mealmaps#auth')->under('/')->to('registration#auth');
  $registration->get('/')->to('registration#show')->name('show_registration');
  $registration->get('/edit')->to('registration#edit')->name('edit_registration');
  $registration->put('/')->to('registration#update')->name('update_registration');

  my $users = $mm->under('/users' => {section => 'users'})->to('mealmaps#auth')->under('/')->to('users#auth');
  $users->get('/')->to('users#index')->name('users');
  $users->get('/add')->to('users#add')->name('add_user');
  $users->post('/')->to('users#store')->name('store_user');
  $users->get('/:user_id')->to('users#show')->name('show_user');
  $users->get('/:user_id/edit')->to('users#edit')->name('edit_user');
  $users->put('/:user_id')->to('users#update')->name('update_user');
  $users->delete('/:user_id')->to('users#remove')->name('remove_user');

  my $profile = $mm->under('/profile' => {section => 'profile'})->to('mealmaps#auth')->under('/')->to('profile#auth');
  $profile->get('/')->to('profile#show')->name('show_profile');
  $profile->get('/edit')->to('profile#edit')->name('edit_profile');
  $profile->put('/')->to('profile#update')->name('update_profile');

  my $recipes = $mm->under('/recipes' => {section => 'recipes'})->to('mealmaps#auth');
  $recipes->get('/')->to('recipes#index');
  $recipes->get('/:meal' => [meal => $meals])->to('recipes#index')->name('meal_recipes');
  $recipes->get('/<id:num>')->to('recipes#show')->name('show_recipe');
  $recipes->get('/<id:num>/pdf')->to('recipes#pdf')->name('recipe_pdf');
  $recipes->get('/<id:num>/img')->to('recipes#img')->name('recipe_img');

  my $plan = $mm->under('/plan' => {section => 'recipes'})->to('mealmaps#auth');
  $plan->get('/<id:num>/add')->to('plan#add')->name('add_to_plan');
  $plan->get('/<id:num>/remove')->to('plan#remove')->name('remove_from_plan');
  $plan->get('/empty/:meal' => {meal => {}})->to('plan#empty')->name('empty_plan');
  $plan->get('/')->to('plan#view')->name('view_plan');
  $plan->get('/print')->to('plan#generate')->name('generate_plan');

  my $admin = $mm->under('/admin' => {section => 'admin'})->to('mealmaps#auth')
    ->under('/')->to('admin#auth');
  my $admin_recipes = $admin->under('/recipes');
  $admin_recipes->get('/rotate')->to('admin-recipes#rotate')->name('rotate_recipes');
  $admin_recipes->get('/create')->to('admin-recipes#create')->name('create_recipe');
  $admin_recipes->post('/')->to('admin-recipes#store')->name('store_recipe');
  $admin_recipes->get('/:id/edit')->to('admin-recipes#edit')->name('edit_recipe');
  $admin_recipes->put('/:id')->to('admin-recipes#update')->name('update_recipe');
  $admin_recipes->delete('/:id')->to('admin-recipes#remove')->name('remove_recipe');
}

1;
