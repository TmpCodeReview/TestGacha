package Gacha::Func::Creator;

use strict;
use warnings;
use utf8;
use Module::Loaded;
use Data::Dumper;

sub create_model {
    my ($model_name) = @_;
    my $model_path = $model_name;

    $model_path =~ s/::/\//g;
    $model_path = "Gacha/Model/$model_path.pm";

    $model_name = "Gacha::Model::$model_name";

    my $result = 1;

    my $loc = is_loaded($model_name);

    if (!$loc) {
        $result = require $model_path;
    }

    my $model = 0;
    if ($result) {
  
        $model = $model_name->new();
    }
    return $model;
}

sub create_service {
    my ($service_name) = @_;
    my $service_path = $service_name;

    $service_path =~ s/::/\//g;
    $service_path = "Gacha/Service/$service_path.pm";

    $service_name = "Gacha::Service::$service_name";

    my $result = 1;

    my $loc = is_loaded($service_name);

    if (!$loc) {
        $result = require $service_path;
    }

    my $service = 0;
    if ($result) {
        $service = $service_name->new();
    }
    return $service;
}

1;
