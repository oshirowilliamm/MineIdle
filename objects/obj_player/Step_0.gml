movimento();
estado();

//y com offset
yy = y - 15;

//voltando cooldown de mineração
if (cooldown_atual > 0) cooldown_atual--;


//debug
ativa_debug();
if (keyboard_check_pressed(ord("R"))) room_restart();

