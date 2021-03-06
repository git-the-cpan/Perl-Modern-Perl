use strict;
use warnings;
if ( $^V =~ /^v5[.](1[13579]|2[1357])/ismx ) {
   print("Perl developer versions are not supported.") and exit;
}
else {
   use ExtUtils::MakeMaker;
   WriteMakefile(
      NAME             => 'Perl::Modern::Perl',
      AUTHOR           => 'Juergen von Brietzke <juergen.von.brietzke@t-online.de>',
      VERSION_FROM     => 'lib/Perl/Modern/Perl.pm',
      ABSTRACT_FROM    => 'lib/Perl/Modern/Perl.pm',
      PL_FILES         => {},
      MIN_PERL_VERSION => '5.012000',
      PREREQ_PM => {
         'Carp'          => 0,
         'English'       => 0,
         'Exporter'      => 0,
         'IO::File'      => 0,
         'IO::Handle'    => 0,
         'Perl::Version' => 0,
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
      dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
      clean => { FILES => 'Perl-Modern-Perl-*' },
   );
}