use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'App::Switch',
    AUTHOR              => q{Mike Larsson <mikelarssonftw@gmail.com>},
    VERSION_FROM        => 'lib/App/Switch.pm',
    ABSTRACT_FROM       => 'lib/App/Switch.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'App-Switch-*' },
);
