package Gacha::Controller::Game;

use strict;
use warnings;
use Digest::MD5 qw(md5_base64);
use Data::Dumper;
use Gacha::Const;
use base qw(Gacha::Controller);

sub index {
    my ($self, $c) = @_;

    my $player_id = $self->get_player_id($c);

    if (!$player_id) {
        return $c->render('index.html' => {});
    }

    my $user_service = $self->s('User');
    my $user = $user_service->get_and_update_current_user_status($player_id);

    my $gacha_service = $self->s('Gacha');
    my $gacha_list = $gacha_service->get_gacha_list($player_id);

    return $c->render('index.html' => {is_login => 1, user => $user, gacha_list => $gacha_list});
}

sub logout {
    my ($self, $c) = @_;

    $c->session->remove('user');
    return  $c->render_json({});
}

sub login {
    my ($self, $c) = @_;
    my $email = $c->req->param('email');
    my $password = $c->req->param('password');

    if (!$email || !$password) {
        return  $c->render_json({'error' => '1', 'error_message' => "Please enter user name and password!"});
    }

    if ($email !~ /^[^@]+@([-\w]+\.)+[a-z]{2,4}$/) {
        return  $c->render_json({'error' => '1', 'error_message' => "Email format invalid!"});
    }

    my $user_service = $self->s('User');

    my $user = $user_service->get_user_data_by_email($email);
    my $password_md5 = md5_base64($password);

    if (!$user) {
        return  $c->render_json({'error' => '1', 'error_message' => "Please enter user name and password!"});
    }

    if ($password_md5 ne $user->{password}) {
        return  $c->render_json({'error' => '1', 'error_message' => "Password incorrect!"});
    }

    $c->session->set('user' => $user->{player_id});

    my $gacha_service = $self->s('Gacha');
    my $gacha_list = $gacha_service->get_gacha_list($user->{player_id});

    return  $c->render_json({'user' => $user, 'gacha_list' => $gacha_list });
}

sub signup {
    my ($self, $c) = @_;

    my $email = $c->req->param('email');
    my $password = $c->req->param('password');
    my $password_confirm = $c->req->param('password_confirm');

    if (!$email || !$password || !$password_confirm || ($password ne $password_confirm)) {
        return  $c->render_json({'error' => '1', 'error_message' => "Input fields is invalid!"});
    }

    if ($email !~ /^[^@]+@([-\w]+\.)+[a-z]{2,4}$/) {
        return  $c->render_json({'error' => '1', 'error_message' => "Email format invalid!"});
    }
    my $user_service = $self->s('User');

    my $user = $user_service->get_user_data_by_email($email);

    if ($user) {
        return  $c->render_json({'error' => '1', 'error_message' => "Email is already used!"});
    }

    my $password_md5 = md5_base64($password);


    my $result = $user_service->register_user($email, $password_md5);

    $user = $user_service->get_user_data_by_email($email);

    if ($result < 0 || !$user) {
        return  $c->render_json({'error' => '1', 'error_message' => "Signup fail!"});
    }

    $c->session->set('user' => $user->{player_id});

    my $gacha_service = $self->s('Gacha');
    my $gacha_list = $gacha_service->get_gacha_list($user->{player_id});

    return  $c->render_json({'user' => $user, 'gacha_list' => $gacha_list });
}

sub inventory {
    my ($self, $c) = @_;

    my $player_id = $self->get_player_id($c);

    if (!$player_id) {
        return $c->render_json({'error' => '1', 'message' => 'Please login!'});
    }

    my $inventory_service = $self->s('Inventory');
    my $user_characters = $inventory_service->get_user_characters($player_id);

    return  $c->render_json({'user_characters' => $user_characters });
}
1;
