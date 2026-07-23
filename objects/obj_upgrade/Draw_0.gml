//só mostra se estiver desbloqueado
if (!upgrade.desbloqueado) exit;

//se desenhando
draw_sprite(sprite_index, upgrade.sprite, x, y);


var _mouse_sobre = position_meeting(mouse_x, mouse_y, id);

//desenhando as infos
if (!_mouse_sobre) exit;

draw_set_font(fnt_upgrades);
draw_set_halign(1);
draw_set_valign(1);



var _margem = 10;

//desenhando fundo
var _wfundo = 200 + _margem;
var _hfundo = 140 + _margem;
var _xfundo = x - sprite_width - 70;
var _yfundo = y - _hfundo - sprite_height / 2;
draw_sprite_stretched(spr_fundo, 0, _xfundo, _yfundo, _wfundo, _hfundo);


//desenhando nome
var _xnome = _xfundo + _wfundo / 2;
var _ynome = _yfundo + _margem;
draw_text(_xnome, _ynome, upgrade.nome);


//linha divisória
var _ylinha = _ynome + _margem;
draw_sprite_stretched(spr_linha, 0, _xfundo, _ylinha, _wfundo, 1);


//desenhando descricao
var _ydesc = _ylinha + _margem * 2;
draw_text(_xnome, _ydesc, upgrade.descricao);


//desenhando o aumento
var _valor = upgrade.valor;
var _prox_valor = _valor * 1.1;
var _texto = string(_valor) + " -> " + string(_prox_valor);
var _yaum = _ydesc + _margem * 2;
draw_text(_xnome, _yaum, _texto);


//linha divisória
var _ylinha2 = _yaum + _margem * 3;
draw_sprite_stretched(spr_linha, 0, _xfundo, _ylinha2, _wfundo, 1);


//desenhando o fundo do level
var _texto_lvl = "Lv. " + string(upgrade.level) + " / " + string(upgrade.level_max);
var _wfundo2 = string_width(_texto_lvl) + _margem;
var _hfundo2 = 20;
var _xfundo2 = _xfundo + 68;
var _yfundo2 = _ylinha2 - _hfundo2 / 2;
draw_sprite_stretched(spr_fundo, 0, _xfundo2, _yfundo2, _wfundo2, _hfundo2);

//desenhando o level
var _xlvl = _xfundo + _wfundo / 2;
draw_text(_xlvl, _ylinha2, _texto_lvl);


//desenhando o custo
var _xcusto = _xnome + 15;
var _ycusto = _ylinha2 + _margem * 3;
draw_set_colour(c_yellow);
draw_text_transformed(_xcusto, _ycusto, upgrade.custo_inicial, 1.5, 1.5, 0);
draw_set_colour(c_white);

//desenhando a moeda
var _xmoeda = _xcusto - string_width(upgrade.custo_inicial) - 15;
frame_moeda = draw_animation(frame_moeda, spr_moeda);
draw_sprite_ext(spr_moeda, frame_moeda, _xmoeda, _ycusto, 2, 2, 0, c_white, 1);


draw_set_font(-1);
draw_set_halign(-1);
draw_set_valign(-1);














