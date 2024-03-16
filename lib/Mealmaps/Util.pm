package Mealmaps::Util;
use Mojo::Base -strict, -signatures;

use Carp qw(croak);
use Exporter qw(import);
# use List::Util qw(max uniq);
# use Mojo::Date;
# use Mojo::File;
use Mojo::JSON qw(decode_json);
# use Mojo::Loader qw(find_packages load_class);
use Mojo::Util qw(b64_decode camelize decamelize dumper md5_sum);
use Locale::Currency::Format qw(FMT_COMMON FMT_NOZEROS);

our @EXPORT_OK = (
  qw(usd),
);

my ($SEED, $COUNTER) = ($$ . time . rand, int rand 0xffffff);

sub currency_set {
  Locale::Currency::Format::currency_set('USD', '$#,###', FMT_COMMON); FMT_COMMON | FMT_NOZEROS
}

sub usd { $#_ == 0 ? Locale::Currency::Format::currency_format('USD', pop, currency_set) : '' }

sub deserialize_signed_cookie ($cookie) {
  decode_json(b64_decode((split /--/, $cookie->value)[0]) =~ s/\}\KZ*$//r)
}

sub id { substr md5_sum($SEED . ($COUNTER = ($COUNTER + 1) % 0xffffff)), 0, 8 }

# sub sum { List::Util::sum0(grep { defined } @_) }

1;
