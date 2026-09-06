//modo debug
#macro DEBUG_MODE false
#macro normal:DEBUG_MODE false
#macro debug:DEBUG_MODE true
global.debug = false;


//fps
#macro FPS game_get_speed(gamespeed_fps)


//transicao
global.transicao = false;
#macro EM_TRANSICAO if (global.transicao) exit


//posição de spawn do player
#macro SPAWN_X_MINA 170
#macro SPAWN_Y_MINA 274

#macro SPAWN_X_VILA 480
#macro SPAWN_Y_VILA 832