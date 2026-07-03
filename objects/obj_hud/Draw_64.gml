#region HUD Debug

if (debug) 
{ 
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
    draw_text(_xnome, _ynome, global.inventario[ITENS.pedra].nome);
    draw_text(_xqtd, _ynome, global.inventario[ITENS.pedra].quantidade);
    
    draw_text(_xnome, _ynome + 30, global.inventario[ITENS.roxo].nome);
    draw_text(_xqtd, _ynome + 30, global.inventario[ITENS.roxo].quantidade);
    
    draw_text(_xnome, _ynome + 60, global.inventario[ITENS.verde].nome);
    draw_text(_xqtd, _ynome + 60, global.inventario[ITENS.verde].quantidade);
    
    draw_text(_xnome, _ynome + 90, global.inventario[ITENS.azul].nome);
    draw_text(_xqtd, _ynome + 90, global.inventario[ITENS.azul].quantidade);
    
    draw_text(_xnome, _ynome + 120, global.inventario[ITENS.amarelo].nome);
    draw_text(_xqtd, _ynome + 120, global.inventario[ITENS.amarelo].quantidade);
    
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
}

#endregion



//desenhando as huds
desenha_sacola();
desenha_stamina();
desenha_moeda();


draw_set_font(-1);