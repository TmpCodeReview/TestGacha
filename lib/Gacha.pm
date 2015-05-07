package Gacha;
use strict;
use warnings;
use utf8;
our $VERSION='0.01';
use 5.008001;
#use Gacha::DB::Schema;
#use Gacha::DB;
use DBI;
#use DBIx::Handler;
use Data::Dumper;
use parent qw/Amon2/;
# Enable project local mode.
__PACKAGE__->make_local_context();
__PACKAGE__->load_plugin(qw/Web::JSON/);

#my $schema = Gacha::DB::Schema->instance;

sub dbh {
    my $c = shift;
    if (!exists $c->{dbh}) {
        my $conf = $c->config->{DBI}
            or die "Missing configuration about DBI";
        my $dbh = DBI->connect(@$conf);
        $c->{dbh} = $dbh;
    }
    $c->{dbh};
}

1;
__END__

=head1 NAME

Gacha - Gacha

=head1 DESCRIPTION

This is a main context class for Gacha

=head1 AUTHOR

Gacha authors.

