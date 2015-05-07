package Gacha::Model::UserCharacter;

use strict;
use warnings;
use utf8;
use Data::Dumper;

use Gacha::Const;

use base qw(Gacha::Model);

sub get_all_data {
    my ($self) = @_;
    my $query = "SELECT * FROM user_character";
    my $result = $self->_fetch($query);
    return $result;
}

sub insert {
    my ($self, $player_id, $character_id) = @_;
    my $query = "INSERT INTO
                    user_character
                (
                    player_id,
                    character_id,
                    reg_date
                ) VALUES (
                    ?,
                    ?,
                    ?)";
    my $data = [
        $player_id,
        $character_id,
        time(),
    ];
    my $result = $self->_store($query, $data);
    return $result;
}

sub get_by_player_id {
    my ($self, $player_id) = @_;

    my $query = "SELECT * FROM user_character WHERE player_id = ?";

    my $data = [
        $player_id,
    ];
    my $result = $self->_fetch($query, $data);
    return $result;
}

1;
