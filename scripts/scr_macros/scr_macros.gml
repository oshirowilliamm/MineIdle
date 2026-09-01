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
