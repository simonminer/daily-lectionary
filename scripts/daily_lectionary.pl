use strict;
use warnings;

use Getopt::Long;
use LWP::Simple qw( get );
use JSON;
use Time::Local;

my ( $day, $month, $year ) = ( localtime() )[ 3 .. 5 ];
my $today = sprintf( "%04d-%02d-%02d", $year + 1900, $month + 1, $day );
my %args = (
    'base-lectionary-url' => 'https://www.lectserve.com/date',
    'base-timecode-url' =>
        'https://dbt.io/audio/versestart?key=<access_key>&dam_id=ENGESVN2DA&osis_code=John&chapter_number=1&v=2',
    'access-token' => '91deda5ad1b17519db360167d216c32c',
    date           => $today,
);
GetOptions(
    'base-lectionary-url=s' => \$args{'base-lectionary-url'},
    'base-timecode-url=s'   => \$args{'base-timecode-url'},
    'access-tokenurl=s'     => \$args{'access-token'},
    'date=s'                => \$args{'date'},
);

############################## Main Program ########################################
#
# Input validation.
die "Invalid date '$args{date}': must be a date formatted as yyyy-mm-dd.\n"
    unless $args{date} =~ m/^\d{4}\-\d{2}\-\d{2}$/;

my $readings = get_readings( $args{date} );

############################## Subroutines ########################################

sub get_readings {
    my ( $date ) = @_;

    # Fetch the readings for the specified date.
    my $url  = "$args{'base-lectionary-url'}/$date";
    my $json = get( $url );
    die "No data returned from request $url.\n" unless $json;

    # Retrieve the lectionary data for the specified date.
    my $data     = JSON::from_json( $json );
    my $readings = $data->{daily}->{readings};

    # Extract the Scripture references for each of the day's readings.
    my $readings_text = "Readings for $date:\n";
    for my $part_of_day ( qw( morning evening ) ) {
        for my $reading_number ( qw( first second ) ) {
            $readings->{$part_of_day}->{$reading_number} =~ s/\s*†\s*/:/;
        }
        $readings_text
            .= '  '
            . lc( $part_of_day )
            . ": $readings->{$part_of_day}->{first}, $readings->{$part_of_day}->{second}\n";
    }

    print $readings_text;

    return $readings;
}

