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
