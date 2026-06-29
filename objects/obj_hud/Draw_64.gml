//barra de stamina
//pegando valor da stamina
var _stamina = (global.stamina_atual / global.stamina_max);

//variaveis pro draw
var _x1 = display_get_gui_width() / 3;
var _y1 = 660;

//mudando cor
var _cor = merge_colour(c_red, c_lime, _stamina);

//mudando largura da stamina
var _width = _stamina * sprite_get_width(spr_barra_stamina);
var _height = sprite_get_height(spr_barra_stamina);

//fundo da stamina
draw_sprite(spr_barra_stamina, 1, _x1, _y1);
//barra da stamina
draw_sprite_stretched_ext(spr_barra_stamina, 0, _x1, _y1, _width, _height, _cor, 1);




#region HUD Debug

if (!debug) exit;

draw_set_font(fnt_itens);
draw_set_colour(c_black);
draw_set_alpha(.6);

var _xnome = 20;
var _xqtd = _xnome + 100;
var _ynome = 20;

//retangulo minerios
draw_rectangle(0, 0, _xnome + 160, _ynome + 210, 0);

//retangulo infos player
draw_rectangle(_xnome + 161, 0, _xnome + 360, _ynome + 210, 0);


draw_set_colour(c_white);

//minerios
draw_text(_xnome, _ynome, global.itens[BLOCOS.pedra].nome);
draw_text(_xqtd, _ynome, global.itens[BLOCOS.pedra].quantidade);

draw_text(_xnome, _ynome + 30, global.itens[BLOCOS.roxo].nome);
draw_text(_xqtd, _ynome + 30, global.itens[BLOCOS.roxo].quantidade);

draw_text(_xnome, _ynome + 60, global.itens[BLOCOS.verde].nome);
draw_text(_xqtd, _ynome + 60, global.itens[BLOCOS.verde].quantidade);

draw_text(_xnome, _ynome + 90, global.itens[BLOCOS.azul].nome);
draw_text(_xqtd, _ynome + 90, global.itens[BLOCOS.azul].quantidade);

draw_text(_xnome, _ynome + 120, global.itens[BLOCOS.amarelo].nome);
draw_text(_xqtd, _ynome + 120, global.itens[BLOCOS.amarelo].quantidade);

var _xmoeda = _xnome + 165;

//moeda
draw_text(_xmoeda, _ynome, "Moeda: " + string(global.moeda));

//stamina
draw_text(_xmoeda, _ynome + 30, "Stamina: " + string(global.stamina_atual));

//upgrades
draw_text(_xmoeda, _ynome + 60, "Dano Picareta: " + string(global.picareta.dano));

draw_set_alpha(1);
draw_set_colour(-1);
draw_set_font(-1);

#endregion