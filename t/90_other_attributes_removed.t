use strict;
use warnings;
use Test::More;
use Test::Fatal;

package Hoge {
  use strict;
  use warnings;
  use Attribute::Handlers;
  use Sub::Util qw( subname );
  sub FETCH_CODE_ATTRIBUTES {
    my ($class, $ref) = @_;
    'Dead';
  }
  sub MODIFY_CODE_ATTRIBUTES {
    my ($class, $ref, @attrs) = @_;
    if ( grep { $_ eq 'Dead' } @attrs ) {
      no strict 'refs';
      no warnings 'redefine';
      *{ subname($ref) } = sub {
        use strict 'refs';
        use warnings 'redefine';
        die 'Dead!';
      };
    }
    ();
  }
}

package Fuga {
  use parent -norequire, 'Hoge';
  sub case_multi_attributes :Dead { $_[0] }
}

package UseFunctionReturn {
  use parent -norequire, 'Hoge';
  use Function::Return;
  sub case_multi_attributes :Dead :Return() { () }
}

like exception { Fuga::case_multi_attributes() }, qr/Dead!/;
like exception { UseFunctionReturn::case_multi_attributes() }, qr/Dead!/;

done_testing;
