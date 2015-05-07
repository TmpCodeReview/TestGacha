package Gacha::Controller::Gacha;

use strict;
use warnings;
use Data::Dumper;
use Gacha::Const;
use base qw(Gacha::Controller);

sub draw_gacha {
    my ($self, $c) = @_;

    my $player_id = $self->get_player_id($c);
    
    if (!$player_id) {
        return $c->render_json({'error' => '1', 'message' => 'Please login!'});
    }

    my $gacha_id = $c->req->param('gacha_id');

    my $gacha_service = $self->s('Gacha');
    my ($user, $character) = $gacha_service->draw_gacha($player_id, $gacha_id);

    if (!$user || !$character) {
        return  $c->render_json({'error' => 1, 'error_message' => 'Can not draw!'});
    }
    return  $c->render_json({'user' => $user, 'character' => $character});
}

1;
