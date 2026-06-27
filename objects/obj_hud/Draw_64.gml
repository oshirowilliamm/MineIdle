draw_set_font(fnt_itens);

var _xnome = 100;
var _xqtd = _xnome + 100;
var _ynome = 350;

draw_text(_xnome, _ynome, "Moeda: " + string(global.moeda));

draw_text(_xnome, _ynome + 50, global.itens[BLOCOS.terra].nome);
draw_text(_xqtd, _ynome + 50, global.itens[BLOCOS.terra].quantidade);

draw_text(_xnome, _ynome + 100, global.itens[BLOCOS.pedra].nome);
draw_text(_xqtd, _ynome + 100, global.itens[BLOCOS.pedra].quantidade);

draw_text(_xnome, _ynome + 150, global.itens[BLOCOS.ferro].nome);
draw_text(_xqtd, _ynome + 150, global.itens[BLOCOS.ferro].quantidade);

draw_text(_xnome, _ynome + 200, global.itens[BLOCOS.ouro].nome);
draw_text(_xqtd, _ynome + 200, global.itens[BLOCOS.ouro].quantidade);

draw_text(_xnome, _ynome + 250, global.itens[BLOCOS.ametista].nome);
draw_text(_xqtd, _ynome + 250, global.itens[BLOCOS.ametista].quantidade);

draw_text(_xnome, _ynome + 300, "Dano Picareta: " + string(global.picareta.dano));

draw_set_font(-1);