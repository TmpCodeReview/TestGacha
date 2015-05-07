package Gacha::Model;

use strict;
use warnings;
use utf8;
use Data::Dumper;

sub new {
    my ( $class, $options ) = @_;
    my $self = +{};
    return bless( $self, $class );
}

sub _fetch {
    my ( $self, $sql, $values ) = @_;

    my $dbh = Gacha->context->dbh;
    my $sth = $dbh->prepare($sql);
    
    my $res = eval { return $sth->execute(@$values); };

    if ($@) {
        my $error = $@;
        my @error_lines = split( ' at', $error );
        die "SQL error: $error_lines[0]";
    }

    return $sth->fetchall_arrayref( {} );
}

sub _store {
    my ( $self, $sql, $values) = @_;
    my $dbh = Gacha->context->dbh;
    my $sth = $dbh->prepare($sql);

    my $res = eval { return $sth->execute(@$values); };

    if ($@) {
        my $error = $@;
        my @error_lines = split( ' at', $error );
        die "SQL error: $error_lines[0]";
    }

    if ( !$res || $res eq '0E0') {
      return 0;
    }
    return $res;
}

1;