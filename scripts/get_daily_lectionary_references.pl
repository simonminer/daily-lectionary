use strict;
use warnings;

use Getopt::Long;
use LWP::Simple qw( get );
use JSON;

my ( $day, $month, $year ) = ( localtime() )[ 3 .. 5 ];
my $today = sprintf( "%04d-%02d-%02d", $year + 1900, $month + 1, $day );
my %args = (
    'base-url' => 'https://www.lectserve.com/date',
    start      => $today,
    end        => $today,
);
GetOptions(
    'base-url=s' => \$args{'base-url'},
    'start=s'    => \$args{'start'},
    'end=s'      => \$args{'end'},
);

# Input validation.
for my $date ( qw( start end ) ) {
    next if $args{$date} =~ m/^\d{4}\-\d{2}\-\d{2}$/;
    die "$date argument must be a date formatted as yyyy-mm-dd.\n";
}

my $current_date = $args{start};
while ( 1 ) {

    # Fetch the current dates lectionary data.
    my $url  = "$args{'base-url'}/$current_date";
    my $data = JSON::from_json( get( $url ) );
    die "No data returned from request $url.\n" unless $data;

    # Parse out and print the Scripture references for each reading.
    my $readings = $data->{daily}->{readings};
    print join( "\t",
        $current_date,                  $readings->{morning}->{first},
        $readings->{morning}->{second}, $readings->{evening}->{first},
        $readings->{evening}->{second} )
        . "\n";

    # Increment the current date if we haven't reach the end.
    last if $current_date eq $args{end};
    $current_date = $data->{daily}->{tomorrow};
}
