package Gacha::Model::UserFreeGachaLog;

use strict;
use warnings;
use utf8;
use Data::Dumper;

use Gacha::Const;

use base qw(Gacha::Model);

sub get_all_data {
    my ($self) = @_;
    my $query = "SELECT * FROM user_free_gacha_log";
    my $result = $self->_fetch($query);
    return $result;
}

sub insert {
    my ($self, $player_id, $gacha_id, $last_draw_time) = @_;
    my $query = "INSERT INTO
                    user_free_gacha_log
                (
                    player_id,
                    gacha_id,
                    last_draw_time
                ) VALUES (
                    ?,
                    ?,
                    ?)";
    my $data = [
        $player_id,
        $gacha_id,
        $last_draw_time,
    ];
    my $result = $self->_store($query, $data);
    return $result;
}

sub get_last_free_gacha_log {
    my ($self, $player_id, $gacha_id) = @_;

        my $query = "SELECT
                        *
                    FROM
                        user_free_gacha_log
                    WHERE
                        player_id = ?
                    AND
                        gacha_id = ?
                    ORDER BY
                        last_draw_time
                    DESC";
    my $data = [
        $player_id,
        $gacha_id,
    ];
    my $result = $self->_fetch($query, $data);

    return scalar(@$result) > 0 ? $result->[0] : 0;
}

1;
