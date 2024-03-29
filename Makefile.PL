use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Sub::Attempt',
    AUTHOR              => q{Aaron Cohen <aarondcohen@gmail.com>},
    VERSION_FROM        => 'lib/Sub/Attempt.pm',
    ABSTRACT_FROM       => 'lib/Sub/Attempt.pm',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Sub-Attempt-*' },
);
