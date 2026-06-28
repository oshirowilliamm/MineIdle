if (!infos) exit;

draw_set_font(fnt_itens);

//variaveis do mouse
var _x = device_mouse_x_to_gui(0);
var _y = device_mouse_y_to_gui(0);

//valor do item
var _valor = "+" + string(global.itens[tipo_bloco].valor);

//variaveis das infos
var _xnome = _x + 20;
var _ynome = _y - 100;
var _xvenda = _xnome + 30;
var _yvenda = _ynome + 50;

//posição do fundo
var _xfundo = _xnome - 20;
var _yfundo = _ynome - 20;

//escala do fundo
var _wnome = string_width(nome);
var _wvenda = string_width(_valor) + sprite_get_width(spr_moeda);
var _wfundo = max(_wnome, _wvenda) + 40;
var _hfundo = 120;

//desenhando fundo
draw_sprite_stretched(spr_fundo, 0, _xfundo, _yfundo, _wfundo, _hfundo);

//nome
draw_text(_xnome, _ynome, nome);
//venda
draw_set_colour(c_lime);
draw_text(_xvenda, _yvenda, _valor);
draw_set_colour(c_white);
//moeda
draw_sprite(spr_moeda, 0, _xvenda - 30, _yvenda);

draw_set_font(-1);