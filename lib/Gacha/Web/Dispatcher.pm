package Gacha::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use Amon2::Web::Dispatcher::RouterBoom;
use Gacha::Controller::Game;
use Gacha::Controller::Gacha;
use File::Basename;
use File::Spec;
my $config_file = dirname(File::Spec->rel2abs(__FILE__)) . "/../conf/pages.conf";
require $config_file;
use Data::Dumper;

1;
