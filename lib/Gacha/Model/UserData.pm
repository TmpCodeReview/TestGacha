package Gacha::Model::UserData;

use strict;
use warnings;
use utf8;
use Data::Dumper;

use Gacha::Const;

use base qw(Gacha::Model);

sub get_user_data {
    my ($self) = @_;
    my $query = "SELECT * FROM user_data";
    my $result = $self->_fetch($query);

    return $result;
}

sub get_user_data_by_email {
    my ($self, $email) = @_;
    my $query = "SELECT * FROM user_data WHERE email = ?";
    my $data = [
        $email,
    ];
    my $result = $self->_fetch($query, $data);

    return scalar(@$result) > 0 ? $result->[0] : 0;
}

sub get_user_data_by_player_id {
    my ($self, $player_id) = @_;
    my $query = "SELECT * FROM user_data WHERE player_id = ?";
    my $data = [
        $player_id,
    ];
    my $result = $self->_fetch($query, $data);

    return scalar(@$result) > 0 ? $result->[0] : 0;
}

sub update_user_status {
    my ($self, $player_id, $last_update, $coin_num) = @_;
    my $query = "UPDATE
                    user_data
                SET
                    last_update = ?,
                    coin_num    = ?
                WHERE
                    player_id = ?";
    my $data = [
        $last_update,
        $coin_num,
        $player_id,
    ];
    my $result = $self->_store($query, $data);
    return $result;
}

sub register_user {
    my ($self, $email, $password) = @_;
    my $query = "INSERT INTO
                    user_data
                (
                    email,
                    password,
                    reg_date,
                    last_update,
                    coin_num
                ) VALUES (
                    ?,
                    ?,
                    ?,
                    ?,
                    ?)";
    my $data = [
        $email,
        $password,
        time(),
        time(),
        $Gacha::Const::INIT_COIN_NUM,
    ];
    my $result = $self->_store($query, $data);
    return $result;
}

1;
