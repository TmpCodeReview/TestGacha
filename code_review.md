## Coding review in detail
### Pros parts

+ Almost all requirements were implemented.
+ Code is well structured with MVC model.
+ Functions are tidy and well formatted.
+ Use place holder parameters for SQL, that's s good practic.
+ Setting up to run is quite simple and easy
+ Code indents are using spaces, that's a good one.
+ Almost all constants are stored in Const.pm.
+ Use base classes for Model/Service/Controller.

### Cons parts

+ Should not use ANY for all APIs
+ Usage of Client Storage Session, that is not good for security, especially for Web API.
+ Some tables don't have primary key or indexes on the searching fields.

>> No PK, need index
CREATE TABLE IF NOT EXISTS `user_gacha_log` (
  `player_id` INTEGER NOT NULL,
  `gacha_id` INTEGER NOT NULL,
  `item_id` INTEGER NOT NULL,
  `draw_time` INTEGER NOT NULL,
  `spent_coin_num` INTEGER NOT NULL
);
CREATE TABLE IF NOT EXISTS `user_free_gacha_log` (
  `player_id` INTEGER NOT NULL,
  `gacha_id` INTEGER NOT NULL,
  `last_draw_time` INTEGER NOT NULL
);

>> Need index:
CREATE TABLE IF NOT EXISTS `user_character` (
  `character_instance_id` INTEGER PRIMARY KEY AUTOINCREMENT,
  `player_id` INTEGER NOT NULL,
  `character_id` INTEGER NOT NULL,
  `reg_date` INTEGER NOT NULL
);

+ Some functions in controller still have logic (Game::login or Game::signup), should use thin controllers.
+ System design is not extendable (some hardcoded should be better design: 

>>
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

).
+ UI does not sync with data system (coins gained counted and displayed only in client side, not sync with server).
+ Should use cached model for master tables.
+ Code is not DRY: dupplicate code somewhere (set_model, get_service, get_all_data)
+ Should use Teng for ORM instead of manually using SQLs (reference: http://search.cpan.org/~nekokak/Teng-0.12/lib/Teng.pm)
+ Don't see DB transaction handle, especially for the DB manipulate requests (like Gacha::draw_gacha). 
+ Should not use hardcoded (eg: $c->render_json({'error' => '1', 'error_message' => "Please enter user name and password!"});)

+ Inconsistent return Gacha::draw_gacha
+ Should use immutable object (User::decrease_user_coin, User::_update_user_coin_recover)

+ No test code. Should write test code.

+ Some others
    + Model::new: $options is not used.
    + Function names should be in consistent format (Gacha::_getTimeStart)
    + Usage of uncommon name (*m = \&get_model;, *s = \&get_service;)
    + Gacha::get_gacha_list this code should be moved to outside of for loop: my $user_free_gacha_log_model = $self->m("UserFreeGachaLog");
    + Gacha::draw_gacha is too complicated.
