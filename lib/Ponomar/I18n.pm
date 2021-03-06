package Ponomar::I18n;

=pod

=head1 Ponomar::I18n

Ponomar::I18n - Internationalization components for Ponomar

=head3 DESCRIPTION

This class handles I18n in Ponomar. Note that at least Perl 5.007 is required, as we must have Unicode support.

=cut

use strict;
# UTF Support is required for I18n!
sub HAVE_UTF8 () { $] >= 5.007003 }

require 5.004;

BEGIN {
	if ( HAVE_UTF8 ) {
		# The string eval helps hide this from Test::MinimumVersion
		eval "require utf8;";
		die "Failed to load UTF-8 support" if $@;
	}
}

require Exporter;
our $VERSION = 0.01;
our @ISA = qw( Exporter );
our @EXPORT = ();
our @EXPORT_OK = qw( getLocaleKey dateToString dateToStringFull);
require Carp;

use YAML::Tiny;

my $_yaml;

my @MONTH_NAMES   = qw(january february march april may june july august september october november december);
my @WEEKDAY_NAMES = qw(sunday monday tuesday wednesday thursday friday saturday);

## poor man's version of POSIX::strftime
sub strftime ($@) {
	my ($format, %convert) = @_;
	$format =~ s#%(.)#$convert{$1}#sg;
	$format;
}

=head3 METHODS

=over 4

=item load($location)

Loads the YAML data in the file, the path of which is C<$location>

=cut

sub load ($) {
	my $file = shift;
	
	unless ($file) {
		Carp::croak("No locale file defined");
	}

	$_yaml = YAML::Tiny->new;
	$_yaml = YAML::Tiny->read( $file );
	Carp::croak (__PACKAGE__ . "::load($file) - Error reading from YAML file.") unless defined $_yaml;
	return 1;
}

=item getLocaleKey($key, $locale)

Returns the appropriate C<$key> in the given C<$language>; e.g.:

	Ponomar::I18n::getLocaleKey('february', 'en') 

returns C<'February'>

=cut

sub getLocaleKey($$) {
	my $key = shift;
	my $locale = shift;

	unless ($_yaml->[0]->{$locale}) {
		Carp::croak ("Error: $locale is not defined in YAML file");
	}
	return $_yaml->[0]->{$locale}->{$key};
}

=item getAvailableLanguages()

Returns an array with the available languages in the Ponomar YAML file

=cut

sub getAvailableLanguages {
	return keys %{ $_yaml->[0] };
}

=item unload()

Unloads the localization, freeing up the memory and destroying the internal YAML::Tiny object.

=cut

sub unload {
	undef $_yaml;
	return 1;
}

=item dateToStringFull($jdate, [$locale])

Returns the fullstring representation of C<$jdate>, a Ponomar::JDate object, in the specified locale. If locale is not specified, C<en> is assumed.

=cut

sub dateToStringFull ($;$) {
	my $date = shift;
	my $locale = shift || "en";
	my %convert = (
		Y => $date->getYear(),
		m => sprintf( '%02d', $date->getMonth() ),
		d => sprintf( '%02d', $date->getDay() ),
		A => getLocaleKey( $WEEKDAY_NAMES[$date->getDayOfWeek()], $locale ),
		B => getLocaleKey( $MONTH_NAMES[$date->getMonth() - 1], $locale )
	);

	my $format = getLocaleKey('date_format_full', $locale);
	return strftime($format, %convert);
}

=item dateToString($jdate, [$locale])

Returns a short string representation of C<$jdate>, a Ponomar::JDate object, in the specified C<$locale>. If C<$locale> is not specified, C<'en'> is assumed.

=cut

sub dateToString ($;$) {
	my $date = shift;
	my $locale = shift || "en";
	my %convert = (
		Y => $date->getYear(),
		m => sprintf( '%02d', $date->getMonth() ),
		d => sprintf( '%02d', $date->getDay() ),
		A => getLocaleKey( $WEEKDAY_NAMES[$date->getDayOfWeek()], $locale ),
		B => getLocaleKey( $MONTH_NAMES[$date->getMonth() - 1], $locale )
	);

	my $format = getLocaleKey('date_format_short', $locale);
	return strftime($format, %convert);
}

=item dateToStringGregorian($jdate, [$locale])

Returns a string representation of C<$jdate>, a Ponomar::JDate object, in the specified C<$locale> on the Gregorian calendar.
If C<$locale> is not specified, C<en> is assumed.

=back

=cut

sub dateToStringGregorian ($;$) {
	my $date = shift;
	my $locale = shift || "en";
	my %convert = (
		Y => $date->getYearGregorian(),
		m => sprintf( '%02d', $date->getMonthGregorian() ),
		d => sprintf( '%02d', $date->getDayGregorian() ),
		A => getLocaleKey( $WEEKDAY_NAMES[$date->getDayOfWeek()], $locale ),
		B => getLocaleKey( $MONTH_NAMES[$date->getMonthGregorian() - 1], $locale )
	);
	my $format = getLocaleKey('date_format_full', $locale);
	return strftime($format, %convert);
}
	
1;

__END__

