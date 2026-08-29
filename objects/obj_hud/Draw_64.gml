//se existir transicao, n desenha a hud
if (instance_exists(obj_transicao)) exit;

desenha_hud();

texto_scribble(20, 20, global.inventario_global.minerios)