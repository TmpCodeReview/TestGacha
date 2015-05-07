package Gacha::Controller;

use strict;
use warnings;
use utf8;
use Gacha::Func::Creator;
use Data::Dumper;
sub new {
    my ( $class, $options ) = @_;

    my $self = +{};

    return bless( $self, $class );
}

*m = \&get_model;
sub get_model {
    my ( $self, $model_name ) = @_;
    return Gacha::Func::Creator::create_model($model_name);
}

*s = \&get_service;
sub get_service {
    my ( $self, $service_name ) = @_;
    return Gacha::Func::Creator::create_service($service_name);
}

sub get_player_id {
    my ( $self, $c ) = @_;
    my $player_id = $c->session->get('user');

    return $player_id;
}
1;