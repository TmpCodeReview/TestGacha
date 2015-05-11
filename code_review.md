## Coding review in detail
### Pros parts

1. Almost all requirements were implemented.
2. Code is well structured with MVC model.
3. Functions are tidy and well formatted.
4. Use place holder parameters for SQL, that's s good practic.
5. Setting up to run is quite simple and easy
6. Code indents are using spaces, that's a good one.
7. Almost all constants are stored in Const.pm.
8. Use base classes for Model/Service/Controller.

### Cons parts

1. Should not use ANY for all APIs
2. Usage of Client Storage Session, that is not good for security, especially for Web API.
3. Some tables don't have primary key or indexes on the searching fields.

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

4. Some functions in controller still have logic (Game::login or Game::signup), should use thin controllers.
5. System design is not extendable (some hardcoded should be better design: 

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
6. UI does not sync with data system (coins gained counted and displayed only in client side, not sync with server).
7. Should use cached model for master tables.
8. Code is not DRY: dupplicate code somewhere (set_model, get_service, get_all_data)
9. Should use Teng for ORM instead of manually using SQLs (reference: http://search.cpan.org/~nekokak/Teng-0.12/lib/Teng.pm)
10. Don't see DB transaction handle, especially for the DB manipulate requests (like Gacha::draw_gacha). 
11. Should not use hardcoded (eg: $c->render_json({'error' => '1', 'error_message' => "Please enter user name and password!"});)
12. Inconsistent return Gacha::draw_gacha
13. Should use immutable object (User::decrease_user_coin, User::_update_user_coin_recover)
14. No test code. Should write test code.

15. Some others
    + Model::new: $options is not used.
    + Function names should be in consistent format (Gacha::_getTimeStart)
    + Usage of uncommon name (*m = \&get_model;, *s = \&get_service;)
    + Gacha::get_gacha_list this code should be moved to outside of for loop: my $user_free_gacha_log_model = $self->m("UserFreeGachaLog");
    + Gacha::draw_gacha is too complicated.
