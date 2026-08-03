
#region HUD Debug

if (debug) 
{ 
    draw_set_font(fnt_debug);
    draw_set_colour(c_black);
    draw_set_alpha(.6);
    
    //retangulo
    draw_rectangle(0, 0, 500, 500, 0);
    
    draw_set_colour(c_white);
    
    #region Cheats
        
        //textos dos cheats
        var _cheats = 
        [
            "CHEATS:",
            "ganhar dinheiro = G", 
            "reiniciar o jogo = R", 
            "ganhar minerios = I",
            "linha de mineração = L",
            "speed do player = V",
            "noclip = N"
        ]
        
        //desenhando os textos
        for (var i = 0; i < array_length(_cheats); i++)
        {
            var _y = 10 + (i * 40);
            draw_text(10, _y, _cheats[i]);
        }
        
    #endregion
    
    #region Minerios
        
        draw_text(300, 10, "MINÉRIOS:");
        
        //desenhando os minerios
        for (var i = 0; i < array_length(global.inventario.minerio); i++)
        {
            var _txt = string(global.inventario.minerio[i].nome) + " = " + string(global.inventario.minerio[i].quantidade);
            var _y = 50 + (i * 40);
            draw_text(300, _y, _txt);
        }
        
    #endregion
    
    #region Outros
        
        //infos
        var _outros = 
        [
            "OUTROS:",
            "Moeda: " + string(global.moeda), 
            "Stamina atual: " + string(global.stamina_atual), 
            "Stamina máxima: " + string(global.stamina_max), 
            "Dano da picareta: " + string(global.picareta.dano),
        ]
        
        //desenhando as infos
        for (var i = 0; i < array_length(_outros); i++)
        {
            var _y = 300 + (i * 40);
            draw_text(10, _y, _outros[i]);
        }
        
    #endregion
    
    //linha vertical no centro
    draw_line(display_get_gui_width() / 2, 0, display_get_gui_width() / 2, room_height);
    //linha horizontal no centro
    draw_line(0, display_get_gui_height() / 2, room_width, display_get_gui_height() / 2);
    
    draw_set_alpha(1);
    draw_set_colour(-1);
    draw_set_font(-1);
}

#endregion



//huds mina   
desenha_sacola();
desenha_stamina();
desenha_botao_voltar();

//huds vila
desenha_moeda();
desenha_inventario();
desenha_voltar();


draw_set_font(-1);