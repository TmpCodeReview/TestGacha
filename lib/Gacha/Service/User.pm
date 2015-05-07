package Gacha::Service::User;

use strict;
use warnings;
use utf8;
use Data::Dumper;
use base qw(Gacha::Service);

sub get_all_user_data {
    my ($self) = @_;
    my $user_model = $self->m('UserData');
    return $user_model->get_user_data();
}

sub register_user {
    my ($self, $email, $password) = @_;
    my $user_model = $self->m('UserData');
    my $result = $user_model->register_user($email, $password);
    return $result;
}

sub get_user_data_by_email {
    my ($self, $email) = @_;

    my $user_model = $self->m('UserData');
    my $user = $user_model->get_user_data_by_email($email);

    if ($user) {
        $self->_update_user_coin_recover($user);
    }

    return $user;
}

sub get_and_update_current_user_status {
    my ($self, $player_id) = @_;

    my $user_model = $self->m('UserData');
    my $user = $user_model->get_user_data_by_player_id($player_id);
    if ($user) {
        $self->_update_user_coin_recover($user);
    }

    return $user;
}

sub decrease_user_coin {
    my ($self, $user, $decrease_coin_num) = @_;

    $user->{coin_num} = $user->{coin_num} - $decrease_coin_num;
    my $user_model = $self->m('UserData');
    $user_model->update_user_status($user->{player_id}, time(), $user->{coin_num});

    return $user;
}

sub _update_user_coin_recover {
    my ($self, $user) =@_;

    my $last_update = $user->{last_update};
    my $now = time();
    my $diff = $now - $last_update;

    my $added_coin = int ( ($now - $last_update) / $Gacha::Const::COIN_RECOVER_TIME );

    if ($added_coin > 0) {
        my $coin_num = $user->{coin_num} + $added_coin;
        $user->{coin_num}  = $coin_num;
        $user->{last_update} = $last_update;

        my $user_model = $self->m('UserData');
        $user_model->update_user_status($user->{player_id}, $now, $coin_num);
    }
    return $user;
}

1;
