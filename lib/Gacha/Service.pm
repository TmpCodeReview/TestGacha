package Gacha::Service;

use strict;
use warnings;
use utf8;

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

1;