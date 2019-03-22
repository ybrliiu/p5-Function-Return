use strict;
use warnings;
use Test::More;

use Function::Return;
use Types::Standard -types;

sub foo {};
is_deeply [__PACKAGE__->FETCH_CODE_ATTRIBUTES(\&foo)], [];

__PACKAGE__->MODIFY_CODE_ATTRIBUTES(\&foo, 'attr');
is_deeply [__PACKAGE__->FETCH_CODE_ATTRIBUTES(\&foo)], ['attr'];


__PACKAGE__->MODIFY_CODE_ATTRIBUTES(\&foo, 'attr', 'Return()');
is_deeply [__PACKAGE__->FETCH_CODE_ATTRIBUTES(\&foo)], ['attr'], 'skip Return()';

eval {
    __PACKAGE__->MODIFY_CODE_ATTRIBUTES(\&foo, 'Return(Hoge)');
};
like $@, qr/Bareword "Hoge" not allowed/, 'invalid type';


__PACKAGE__->MODIFY_CODE_ATTRIBUTES(\&foo, 'Return(Str)');
is_deeply [ __PACKAGE__->FETCH_CODE_ATTRIBUTES(\&foo) ], [];

done_testing;
