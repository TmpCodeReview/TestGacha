package Gacha::Model::UserGachaLog;

use strict;
use warnings;
use utf8;
use Data::Dumper;

use Gacha::Const;

use base qw(Gacha::Model);

sub get_all_data {
    my ($self) = @_;
    my $query = "SELECT * FROM user_gacha_log";
    my $result = $self->_fetch($query);
    return $result;
}

sub insert {
    my ($self, $player_id, $gacha_id, $item_id, $draw_time, $spent_coin_num) = @_;
    my $query = "INSERT INTO
                    user_gacha_log
                (
                    player_id,
                    gacha_id,
                    item_id,
                    draw_time,
                    spent_coin_num
                ) VALUES (
                    ?,
                    ?,
                    ?,
                    ?,
                    ?)";
    my $data = [
        $player_id,
        $gacha_id,
        $item_id,
        $draw_time,
        $spent_coin_num
    ];
    my $result = $self->_store($query, $data);
    return $result;
}

sub get_gacha_log {
    my ($self, $player_id, $gacha_id, $start_time) = @_;

        my $query = "SELECT
                        *
                    FROM
                        user_gacha_log
                    WHERE
                        player_id = ?
                    AND
                        gacha_id = ?
                    AND
                        draw_time >= ?";
    my $data = [
        $player_id,
        $gacha_id,
        $start_time,
    ];

    my $result = $self->_fetch($query, $data);

    return $result;
}

1;
