package Gacha::Service::Gacha;

use strict;
use warnings;
use utf8;
use List::Util;
use Time::Local;

use Data::Dumper;
use base qw(Gacha::Service);

sub get_gacha_list {
    my ($self, $player_id) = @_;

    my $gacha_master = $self->m('GachaMaster');
    my $result = $gacha_master->get_all_data();

    my $now = time();
    for my $gacha (@$result) {

        my $gacha_type = $gacha->{gacha_type};

        my $user_free_gacha_log_model = $self->m("UserFreeGachaLog");

        my $last_free_gacha_log = $user_free_gacha_log_model->get_last_free_gacha_log($player_id, $gacha->{gacha_id});

        my $is_free = 0;

        if  ($gacha->{gacha_type} == $Gacha::Const::GACHA_TYPE->{box}) {
            $is_free = 0;
        }
        elsif (!$last_free_gacha_log) {
            $is_free = 1;
        }
        else {
            my $last_free_draw_time = $last_free_gacha_log ? $last_free_gacha_log->{last_draw_time} : 0;
            my $draw_time_diff = $now - $last_free_draw_time;

            if ($gacha->{gacha_type} == $Gacha::Const::GACHA_TYPE->{normal}) {
                $is_free = ($draw_time_diff >= $Gacha::Const::FREE_GACHA_RESPAWN_TIME->{normal}) ? 1 : 0;
            }
            elsif ($gacha->{gacha_type} == $Gacha::Const::GACHA_TYPE->{expensive}) {
                $is_free = ($draw_time_diff >= $Gacha::Const::FREE_GACHA_RESPAWN_TIME->{expensive}) ? 1 : 0;
            }
        }

        if ($is_free) {
            $gacha->{price} = 0;
        }
    }

    return $result;
}

sub draw_gacha {
    my ($self, $player_id, $gacha_id) = @_;

    my $gacha_master = $self->m('GachaMaster');
    
    my $user_gacha_log_model = $self->m("UserGachaLog");
    my $gacha_weight_master = $self->m('GachaWeightMaster');
    my $user_service = $self->s('User');

    my $user = $user_service->get_and_update_current_user_status($player_id);
    my $gacha = $gacha_master->get_by_gacha_id($gacha_id);
    my $gacha_type = $gacha->{gacha_type};
    my $gacha_drop_info = $self->m('GachaWeightMaster')->get_by_gacha_id($gacha_id);

    my $now = time();
    my $is_free = 0;

    my $user_free_gacha_log_model = $self->m("UserFreeGachaLog");
    my $last_free_gacha_log = $user_free_gacha_log_model->get_last_free_gacha_log($player_id, $gacha_id);

    if ($gacha_type == $Gacha::Const::GACHA_TYPE->{box}) {
        $is_free = 0;
        $gacha_drop_info = $self->_get_drop_info_for_box_gacha($player_id, $gacha_id, $gacha_drop_info);
    }
    elsif (!$last_free_gacha_log) {
        $is_free = 1;
    }
    else {
        my $last_free_draw_time = $last_free_gacha_log ? $last_free_gacha_log->{last_draw_time} : 0;
        my $draw_time_diff = $now - $last_free_draw_time;

        if ($gacha->{gacha_type} == $Gacha::Const::GACHA_TYPE->{normal}) {
            $is_free = ($draw_time_diff >= $Gacha::Const::FREE_GACHA_RESPAWN_TIME->{normal}) ? 1 : 0;
        }
        elsif ($gacha->{gacha_type} == $Gacha::Const::GACHA_TYPE->{expensive}) {
            $is_free = ($draw_time_diff >= $Gacha::Const::FREE_GACHA_RESPAWN_TIME->{expensive}) ? 1 : 0;
        }
    }

    my $spent_coin = $is_free ? 0 : $gacha->{price};

    if ($user->{coin_num} < $spent_coin) {
        return 0;
    }

    my $gacha_result = $self->_determine_reward_by_random($gacha_drop_info);

    if ($gacha_result) {
        my $character_id = $gacha_result->{item_id};

        my $character_master = $self->m('CharacterMaster');
        my $character = $character_master->get_by_character_id($character_id);

        my $user_character_model = $self->m("UserCharacter");
        $user_character_model->insert($player_id, $character_id);

        $user_gacha_log_model->insert($player_id, $gacha_id, $character_id, $now, $spent_coin);

        if ($spent_coin == 0) {
            $user_free_gacha_log_model->insert($player_id, $gacha_id, $now);
        }
        else {
            $user = $user_service->decrease_user_coin($user, $spent_coin);
        }

        return ($user, $character)
    }

    return 0;
}

sub _get_drop_info_for_box_gacha {
    my ($self, $player_id, $gacha_id, $gacha_drop_info) = @_;

    my $box_gacha_drop_info = [];

    my $box_gacha_logs = $self->_get_box_gacha_log($player_id, $gacha_id);

    for my $drop_info (@$gacha_drop_info) {
        my $got_item = 0;
        for my $log (@$box_gacha_logs) {
            if ($drop_info->{item_id} == $log->{item_id}) {
                $got_item = 1;
                next;
            }
        }
        if ($got_item != 1) {
            push (@$box_gacha_drop_info, $drop_info);
        }
    }

    return $box_gacha_drop_info;
}

sub _get_box_gacha_log {
    my ($self, $player_id, $gacha_id) = @_;
    my $now = time();

    my $start_time = $self->_getTimeStart($now);

    my $user_gacha_log_model = $self->m('UserGachaLog');

    my $user_gacha_log = $user_gacha_log_model->get_gacha_log($player_id, $gacha_id, $start_time);

    return $user_gacha_log;
}

sub _getTimeStart {
    my ($self, $time) = @_;
    $time = time() if (!$time);
    my @t = localtime($time);
    return Time::Local::timelocal(0, 0, 0, $t[3], $t[4], $t[5]);
}

sub _determine_reward_by_random {
    my ($self, $gacha_drop_info) = @_;

    my $weight_sum = 0;
    for my $drop_data (@$gacha_drop_info) {
        $weight_sum += $drop_data->{weight};
    }

    my $rate = int (rand($weight_sum));
    my $accum_weight = 0;
    my $result;

    for my $drop_data (@$gacha_drop_info) {
        $accum_weight += $drop_data->{weight};
        if ($rate < $accum_weight) {
            $result = $drop_data;
            last;
        }
    }

    return $result;
}

1;
