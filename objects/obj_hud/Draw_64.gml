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
draw_text(_xnome, _ynome, global.itens[BLOCOS.terra].nome);
draw_text(_xqtd, _ynome, global.itens[BLOCOS.terra].quantidade);

draw_text(_xnome, _ynome + 30, global.itens[BLOCOS.pedra].nome);
draw_text(_xqtd, _ynome + 30, global.itens[BLOCOS.pedra].quantidade);

draw_text(_xnome, _ynome + 60, global.itens[BLOCOS.ferro].nome);
draw_text(_xqtd, _ynome + 60, global.itens[BLOCOS.ferro].quantidade);

draw_text(_xnome, _ynome + 90, global.itens[BLOCOS.ouro].nome);
draw_text(_xqtd, _ynome + 90, global.itens[BLOCOS.ouro].quantidade);

draw_text(_xnome, _ynome + 120, global.itens[BLOCOS.ametista].nome);
draw_text(_xqtd, _ynome + 120, global.itens[BLOCOS.ametista].quantidade);

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