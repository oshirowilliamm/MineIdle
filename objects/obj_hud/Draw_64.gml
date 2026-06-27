draw_set_font(fnt_itens);
draw_set_colour(c_black);

var _xnome = 20;
var _xqtd = _xnome + 100;
var _ynome = 20;

//retangulo
draw_rectangle(0, 0, _xnome + 160, _ynome + 210, 0);

draw_set_colour(c_white);

//nomes
draw_text(_xnome, _ynome, "Moeda: " + string(global.moeda));

draw_text(_xnome, _ynome + 30, global.itens[BLOCOS.terra].nome);
draw_text(_xqtd, _ynome + 30, global.itens[BLOCOS.terra].quantidade);

draw_text(_xnome, _ynome + 60, global.itens[BLOCOS.pedra].nome);
draw_text(_xqtd, _ynome + 60, global.itens[BLOCOS.pedra].quantidade);

draw_text(_xnome, _ynome + 90, global.itens[BLOCOS.ferro].nome);
draw_text(_xqtd, _ynome + 90, global.itens[BLOCOS.ferro].quantidade);

draw_text(_xnome, _ynome + 120, global.itens[BLOCOS.ouro].nome);
draw_text(_xqtd, _ynome + 120, global.itens[BLOCOS.ouro].quantidade);

draw_text(_xnome, _ynome + 150, global.itens[BLOCOS.ametista].nome);
draw_text(_xqtd, _ynome + 150, global.itens[BLOCOS.ametista].quantidade);

draw_text(_xnome, _ynome + 180, "Dano Picareta: " + string(global.picareta.dano));

draw_set_colour(-1);
draw_set_font(-1);