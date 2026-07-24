draw_set_font(fnt_upgrades);
draw_set_halign(1);

//só mostra se estiver desbloqueado
if (!upgrade.desbloqueado) exit;

//se desenhando
draw_sprite(sprite_index, upgrade.sprite, x, y);

//desenhando as infos dos upgrades
draw_set_colour(c_yellow);
desenha_infos();
draw_set_colour(c_white);

draw_set_font(-1);
draw_set_halign(-1);