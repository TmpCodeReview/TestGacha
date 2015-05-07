package Gacha::Service::Inventory;

use strict;
use warnings;
use utf8;
use Data::Dumper;
use base qw(Gacha::Service);

sub get_user_characters {
    my ($self, $player_id) = @_;

    my $user_character_model = $self->m('UserCharacter');

    my $user_characters = $user_character_model->get_by_player_id($player_id);

    my $character_master = $self->m('CharacterMaster');
    my $all_characters = $character_master->get_all_data();
    for my $user_character (@$user_characters) {
        my ($character) = grep {$user_character->{character_id} == $_->{character_id}} @$all_characters;

        if ($character) {
            $user_character->{character_name} = $character->{name};
            $user_character->{character_rarity} = $character->{rarity};
        }
    }
    return $user_characters;
}

1;
