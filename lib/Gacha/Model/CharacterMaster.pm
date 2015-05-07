package Gacha::Model::CharacterMaster;

use strict;
use warnings;
use utf8;
use Data::Dumper;

use Gacha::Const;

use base qw(Gacha::Model);

sub get_all_data {
    my ($self) = @_;
    my $query = "SELECT * FROM character_master";
    my $result = $self->_fetch($query);
    return $result;
}

sub get_by_character_id {
    my ($self, $character_id) = @_;
    my $query = "SELECT * FROM character_master WHERE character_id = ?";
    my $data = [
        $character_id,
    ];
    my $result = $self->_fetch($query, $data);

    return scalar(@$result) > 0 ? $result->[0] : 0;
}

1;
