package Gacha::Model::GachaMaster;

use strict;
use warnings;
use utf8;
use Data::Dumper;

use Gacha::Const;

use base qw(Gacha::Model);

sub get_all_data {
    my ($self) = @_;
    my $query = "SELECT * FROM gacha_master";
    my $result = $self->_fetch($query);
    return $result;
}

sub get_by_gacha_id {
    my ($self, $gacha_id) = @_;
    my $query = "SELECT * FROM gacha_master WHERE gacha_id = ?";
    my $data = [
        $gacha_id,
    ];
    my $result = $self->_fetch($query, $data);

    return scalar(@$result) > 0 ? $result->[0] : 0;
}

1;
