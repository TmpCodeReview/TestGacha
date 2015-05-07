package Gacha::Const;

use strict;
use warnings;

our $INIT_COIN_NUM  = 5000;

our $GACHA_TYPE = +{
    normal      => 1,
    expensive   => 2,
    box         => 3,
};

our $GAME_GACHA_IDS = +{
    normal      => 1001,
    expensive   => 2001,
    box         => 2001,
};

our $NORMAL_GACHA_ID = 1001;

our $COIN_RECOVER_TIME = 1; # 1 second

our $FREE_GACHA_RESPAWN_TIME = +{
    normal      => 3600, # 1 hour
    expensive   => 86400, # 1 day
};

1;
