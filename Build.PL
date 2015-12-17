use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'Perl::Modern::Perl',
    license             => 'artistic2',
    dist_author         => 'Juergen von Brietzke <juergen.von.brietzke@t-online.de>',
    dist_version_from   => 'lib/Perl/Modern/Perl.pm',
    requires => {
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
    build_requires => {
        'Test::More'          => 0,
        'Test::Perl::Critic'  => 0,
        'Test::Pod'           => 1.14,
        'Test::Pod::Coverage' => 1.04,
    },
    add_to_cleanup      => [ 'Perl-Modern-Perl-*' ],
);

$builder->create_build_script();
