package Mealmaps::Controller::Recipes;
use Mojo::Base 'Mojolicious::Controller', -signatures;

use Mojo::Util qw(b64_encode);

sub create { shift->render(recipe => {}) }

sub edit {
  my $self = shift;
  $self->render(recipe => $self->recipes->find($self->param('id')));
}

sub index {
  my $self = shift;
  my $meal = $self->param('meal');
  $self->render(meal => $meal, recipes => $self->recipes->all($meal));
}

sub remove {
  my $self = shift;
  $self->recipes->remove($self->param('id'));
  $self->redirect_to('recipes');
}

sub rotate {
  my $self = shift;
  $self->recipes->rotate;
  $self->redirect_to('recipes');
}

sub show {
  my $self = shift;
  $self->render(recipe => $self->recipes->find($self->param('id')));
}

sub store {
  my $self = shift->render_later;

  my $validation = $self->_validation;
  return $self->render(action => 'create', recipe => {})
    if $validation->has_error;

  my $pdf = delete $validation->output->{pdf};
  #my $img = delete $validation->output->{img};
  my $id = $self->recipes->add($validation->output);
  $pdf->move_to($self->app->home->child('public', 'recipes')->make_path->child("$id.pdf"));
  my $url = Mojo::URL->new($self->config->{convertapi}->{url});
  $url->query({Secret => $self->config->{convertapi}->{secret}});
  $self->ua->post("$url" => json => {
    Parameters => [
      {
        Name => 'File',
        FileValue => {
          Name => 'file.pdf',
          Data => b64_encode($pdf->slurp),
        }
      },
      {
        Name => 'StoreFile',
        Value => Mojo::JSON->true,
      },
    ],
  } => sub {
    my ($ua, $tx) = @_;
    my $res = $tx->result;
    return $self->reply->exception($res->message) unless $res->is_success;
    $self->ua->get($res->json->{Files}[0]{Url} => sub ($ua, $tx) {
      $tx->res->content->asset->move_to($self->app->home->child('public', 'recipes')->make_path->child("$id.png"));
      $self->redirect_to('show_recipe', id => $id);
    });
  });
  #$img->move_to($self->app->home->child('public', 'recipes')->make_path->child("$id.png"));
}

sub update {
  my $self = shift;

  my $validation = $self->_validation;
  return $self->render(action => 'edit', recipe => {}) if $validation->has_error;

  my $pdf = delete $validation->output->{pdf};
  #my $img = delete $validation->output->{img};
  my $id = $self->param('id');
  $self->recipes->save($id, $validation->output);
  $pdf->move_to($self->app->home->child('public', 'recipes')->make_path->child("$id.pdf")) if $pdf;
  my $url = Mojo::URL->new($self->config->{convertapi}->{url});
  $url->query({Secret => $self->config->{convertapi}->{secret}});
  $self->ua->post("$url" => json => {
    Parameters => [
      {
        Name => 'File',
        FileValue => {
          Name => 'file.pdf',
          Data => b64_encode($pdf->slurp),
        }
      },
      {
        Name => 'StoreFile',
        Value => Mojo::JSON->true,
      },
    ],
  } => sub {
    my ($ua, $tx) = @_;
    my $res = $tx->result;
    return $self->reply->exception($res->message) unless $res->is_success;
    $self->ua->get($res->json->{Files}[0]{Url} => sub ($ua, $tx) {
      $tx->res->content->asset->move_to($self->app->home->child('public', 'recipes')->make_path->child("$id.png"));
      $self->redirect_to('show_recipe', id => $id);
    });
  });
  #$img->move_to($self->app->home->child('public', 'recipes')->make_path->child("$id.png")) if $img;
}

sub _validation {
  my $self = shift;

  my $validation = $self->validation;
  $validation->required('title', 'not_empty');
  $validation->optional('pdf')->upload;
  #$validation->optional('img')->upload;
  $validation->required('recipe',  'not_empty');
  $validation->required('shopping_list',  'not_empty');
  $validation->required('meal',  'not_empty');

  return $validation;
}

1;
