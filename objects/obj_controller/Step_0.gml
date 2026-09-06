restart();

if (keyboard_check_pressed(vk_f11)) window_set_fullscreen(!window_get_fullscreen());
if (keyboard_check_pressed(vk_f10)) game_end();