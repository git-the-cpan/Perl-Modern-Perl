use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'Perl::Modern::Perl',
    AUTHOR              => 'Juergen von Brietzke <juergen.von.brietzke@t-online.de>',
    VERSION_FROM        => 'lib/Perl/Modern/Perl.pm',
    ABSTRACT_FROM       => 'lib/Perl/Modern/Perl.pm',
    PL_FILES            => {},
    PREREQ_PM => {
        'Carp'          => 0,
        'English'       => 0,
        'Perl::Version' => 0,
        'Test::More'    => 0,
        'feature'       => 0,
        'mro'           => 0,
        'strict'        => 0,
        'version'       => 0,
        'warnings'      => 0,
    },
    BUILD_REQUIRES => {
        'Test::More'          => 0,
        'Test::Pod'           => 1.14,
        'Test::Pod::Coverage' => 1.04,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Perl-Modern-Perl-*' },
);
