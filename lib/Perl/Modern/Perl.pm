# ##############################################################################
# # Script     : Perl::Modern::Perl                                            #
# # -------------------------------------------------------------------------- #
# # Copyright  : Frei unter GNU General Public License  bzw.  Artistic License #
# # Authors    : JVBSOFT - J�rgen von Brietzke                   0.001 - 1.004 #
# # Version    : 1.004                                             19.Dez.2015 #
# # -------------------------------------------------------------------------- #
# # Function   : L�dt alle Features der aktuellen benutzten Perl-Version.      #
# # -------------------------------------------------------------------------- #
# # Language   : PERL 5                                (V) 5.10.xx  -  5.22.xx #
# # Coding     : ISO 8859-15 / Latin-9                         UNIX-Zeilenende #
# # Standards  : Perl-Best-Practices                       severity 1 (brutal) #
# # -------------------------------------------------------------------------- #
# # Pragmas    : feature, mro, strict, version, warnings                       #
# # -------------------------------------------------------------------------- #
# # Module     : Carp                                   ActivePerl-CORE-Module #
# #              English                                                       #
# #              ------------------------------------------------------------- #
# #              Perl::Version                          ActivePerl-REPO-Module #
# ##############################################################################

package Perl::Modern::Perl 1.004;

# ##############################################################################

use 5.012;

use feature ();
use mro     ();
use strict;
use version;
use warnings;

use Carp;
use English qw{-no_match_vars};
use Perl::Version;

# ##############################################################################
# # Feature/Warnings-Table : Enthaelt alle verfuegbaren Features bis Perl 5.22 #
# # -------------------------------------------------------------------------- #
# # 5.xx  <->  Feature ist im Feature-Tag enthalten ( ':5.xx' )                #
# # ++++  <->  Feature ist in der Perl-Version zuschaltbar                     #
# # ----  <->  Feature ist in der Perl-Version nicht implementiert             #
# ##############################################################################

our %FEATURES = (
# ------ Perl-Version ----- 5.10 5.12 5.14 5.16 5.18 5.20 5.22 -----------------
   array_base      => [ qw( 5.10 5.12 5.14 ++++ ++++ ++++ ++++ ) ],
   bitwise         => [ qw( ---- ---- ---- ---- ---- ---- ++++ ) ],
   current_sub     => [ qw( ---- ---- ---- 5.16 5.18 5.20 5.22 ) ],
   evalbytes       => [ qw( ---- ---- ---- 5.16 5.18 5.20 5.22 ) ],
   fc              => [ qw( ---- ---- ---- 5.16 5.18 5.20 5.22 ) ],
   lexical_subs    => [ qw( ---- ---- ---- ---- ++++ ++++ ++++ ) ],
   postderef       => [ qw( ---- ---- ---- ---- ---- ++++ ++++ ) ],
   postderef_qq    => [ qw( ---- ---- ---- ---- ---- ++++ ++++ ) ],
   refaliasing     => [ qw( ---- ---- ---- ---- ---- ---- ++++ ) ],
   say             => [ qw( 5.10 5.12 5.14 5.16 5.18 5.20 5.22 ) ],
   signatures      => [ qw( ---- ---- ---- ---- ---- ++++ ++++ ) ],
   state           => [ qw( 5.10 5.12 5.14 5.16 5.18 5.20 5.22 ) ],
   switch          => [ qw( 5.10 5.12 5.14 5.16 5.18 5.20 5.22 ) ],
   unicode_eval    => [ qw( ---- ---- ---- 5.16 5.18 5.20 5.22 ) ],
   unicode_strings => [ qw( ---- 5.12 5.14 5.16 5.18 5.20 5.22 ) ],
);

our %WARNINGS = (
# ----- Perl-Version ------ 5.10 5.12 5.14 5.16 5.18 5.20 5.22 -----------------
   autoderef       => [ qw( ---- ---- ---- ---- ---- 5.20 5.22 ) ],
   bitwise         => [ qw( ---- ---- ---- ---- ---- ---- 5.22 ) ],
   const_attr      => [ qw( ---- ---- ---- ---- ---- ---- 5.22 ) ],
   lexical_subs    => [ qw( ---- ---- ---- ---- 5.18 5.20 5.22 ) ],
   lexical_topic   => [ qw( 5.10 5.12 5.14 5.16 5.18 5.20 5.22 ) ],
   postderef       => [ qw( ---- ---- ---- ---- ---- 5.20 5.22 ) ],
   re_strict       => [ qw( ---- ---- ---- ---- ---- ---- 5.22 ) ],
   refaliasing     => [ qw( ---- ---- ---- ---- ---- ---- 5.22 ) ],
   regex_sets      => [ qw( ---- ---- ---- ---- 5.18 5.20 5.22 ) ],
   signatures      => [ qw( ---- ---- ---- ---- ---- 5.20 5.22 ) ],
   smartmatch      => [ qw( ---- ---- ---- ---- 5.18 5.20 5.22 ) ],
);

# ##############################################################################
# # Aufgabe   | Importiert die experimentellen Features einer Perl-Version.    #
# # ----------+ -------------------------------------------------------------- #
# # Aufruf    | use Perl::Features qw( [ 5.22 [ say [ -state ... ] ] ] );      #
# #           | -------------------------------------------------------------- #
# #           | Importiert alle Featurs von Perl 5.22 ausser 'say' und 'state. #
# # ----------+--------------------------------------------------------------- #
# # R�ckgabe  | keine                                                          #
# ##############################################################################

sub import {

   my ( $class, $version, @delete_features_or_warnings ) = @ARG;

   my ( $actual_perl_version, $use_perl_version, $version_tag, $version_idx );

   # --- Aktuelle PERL-Version bestimmen und Feature-Tag bilden ----------------
   if ( $PERL_VERSION =~ /^v5[.](\d\d).+$/smx ) {
      $actual_perl_version = "5.$1";
      $use_perl_version    = "5.0$1";
   }
   else {
      confess "Version '$PERL_VERSION' not detected\n";
   }

   # --- Versions-String pruefen und Feature-Tag bilden ------------------------
   if ( not $version ) {
      $version = $actual_perl_version;
   }
   if ( $version =~ /^5[.](1[13579]|2[13])$/ismx ) {
      my $current_main_version = $1 - 1;
      $version = "5.$current_main_version";
   }
   if ( $version =~ /^5[.](1[02468]|2[02])$/ismx ) {
      $use_perl_version = "5.0$1";
      $version_idx      = $1 / 2 - 5;
      $version_tag      = ":$version";
   }
   else {
      confess "Version ($version) not supports\n";
   }

   # --- Testen ob die aktuelle PERL-Version groesser gleich Feature-Version ---
   my $perl_version    = Perl::Version->new($actual_perl_version);
   my $feature_version = Perl::Version->new($version);
   if ( $perl_version < $feature_version ) {
      confess "Features '$version' in '$actual_perl_version' not available\n";
   }

   # --- PERL-Version aktivieren und Features importieren ----------------------
   my $use = "use qw{$use_perl_version}";
   eval { $use } or confess "Can't execute '$use'\n";
   warnings->import;
   strict->import;
   version->import;
   feature->import( $version_tag );
   mro::set_mro( scalar caller(), 'c3' );

   # --- Zusatz-Features importieren -------------------------------------------
   foreach my $feature ( keys %FEATURES ) {
      if ( $FEATURES{$feature}->[$version_idx] eq '++++' ) {
         feature->import($feature);
      }
   }

   # --- Warnmeldung fuer importierte Features ausschalten ---------------------
   foreach my $warning ( keys %WARNINGS ) {
      if ( $WARNINGS{$warning}->[$version_idx] ne '----' ) {
         warnings->unimport( "experimental::$warning" );
      }
   }

   # --- Einzelne Features entfernen / einzelne Warnungen einschalten ----------
   my $flag;
   foreach my $delete ( @delete_features_or_warnings ) {
      $flag = 0;
      $delete =~ s/^[-](.+)/$1/smx;
      if ( exists $FEATURES{$delete} ) {
         $flag = 1;
         if ( $FEATURES{$delete}->[$version_idx] ne '----' ) {
            feature->unimport($delete);
         }
         else {
            confess "Feature '$delete' in version '$version' not available\n"
         }
      }
      if ( exists $WARNINGS{$delete} ) {
         $flag = 1;
         if ( $WARNINGS{$delete}->[$version_idx] ne '----' ) {
            warnings->import( "experimental::$delete" );
         }
      }
      if ( not $flag ) {
         confess "Unknown feature/warning for delete '$delete'\n";
      }
   }

   return;

}

# ##############################################################################
# # Aufgabe   | Entfernt alle experimentellen Features einer Perl-Version.     #
# # ----------+ -------------------------------------------------------------- #
# # R�ckgabe  | keine                                                          #
# ##############################################################################

sub unimport {

   warnings->unimport;
   strict->unimport;
   feature->unimport;

   return;

}

# ##############################################################################
# #                                  E N D E                                   #
# ##############################################################################
1;
__END__

=head1 NAME

Perl::Modern::Perl - Loads all features of the current used version of Perl.


=head1 VERSION

This document describes Perl::Modern::Perl version 1.004.


=head1 SYNOPSIS

   use Perl::Modern::Perl;
   or
   use Perl::Modern:Perl qw{5.20};
   or
   use Perl::Modern::Perl qw{5.18 -switch}


=head1 DESCRIPTION

Loads all features of the current version of Perl used or the specified version
of Perl. The corresponding warnings are deactivated.
If a version of Perl specified, this must be less than or equal to the
installed. Should one or more features can not be activated this be specified
after the version (the minus sign is optional).


=head1 INTERFACE

Contains no routines that are invoked explicitly.


=head2 import

Called automatically when integrating.


=head2 unimport

Called automatically when you leave the name space.


=head1 DIAGNOSTICS

=head2 Version '5.xx' not detected

The version of the installed PERL could not be determined.

=head2 Version (5.xx) not supports

The transferred PERL version is not supported.

=head2 Features '5.xx' in '5.xx' not available

he requested PERL version is higher than the installed.

=head2 Can't execute 'use qw{5.xx}'

The requested PERL version can not be activated.

=head2 Feature 'xxxxx' in version '5.xx' not available.

he feature to be removed is not included in the selected version of Perl.

=head2 Unknown feature/warning for delete 'xxxxx'

The feature to be removed is unknown.


=head1 CONFIGURATION AND ENVIRONMENT

Perl::Modern::Perl requires no configuration files or environment variables.


=head1 DEPENDENCIES

The following pragmas and modules are required:

=head2 CORE

   - feature
   - mro
   - strict
   - version
   - warnings

   - Carp
   - English


=head2 CPAN or ActiveState Repository

   - Perl::Version


=head1 INCOMPATIBILITIES

The module works with Perl version 5.12, 5.14, 5.16, 5.18, 5.20 and 5.22.
Developers Perl versions are not supported. It state is toggled to the previous
major version.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-perl-modern-moose@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org>.


=head1 AUTHOR

Juergen von Brietzke  C<< <juergen.von.brietzke@t-online.de> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2015,
Juergen von Brietzke C<< <juergen.von.brietzke@t-online.de> >>.
All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
