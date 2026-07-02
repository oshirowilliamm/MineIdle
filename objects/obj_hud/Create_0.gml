debug = false;
frame = 0;
itens_caindo = [];
peso_atual = global.peso_atual;

//desenhando a barra de stamina
desenha_stamina = function()
{
    //não desenha em sala de upgrades
    if (room == rm_venda || room == rm_upgrade) exit;
    
    //pegando valor da stamina
    var _stamina = (global.stamina_atual / global.stamina_max);
    
    //variaveis pro draw
    var _x = display_get_gui_width() / 3;
    var _y = 660;
    
    //mudando cor
    var _cor = merge_colour(c_red, c_lime, _stamina);
    
    //mudando largura da stamina
    var _width = _stamina * sprite_get_width(spr_barra_stamina);
    var _height = sprite_get_height(spr_barra_stamina);
    
    //fundo da stamina
    draw_sprite(spr_barra_stamina, 1, _x, _y);
    //barra da stamina
    draw_sprite_stretched_ext(spr_barra_stamina, 0, _x, _y, _width, _height, _cor, 1);
}

//desenhando a sacola que guarda os itens
desenha_sacola = function()
{
    //variaveis pro draw
    var _escala = 5;
    var _x = display_get_gui_width() - 90;
    var _y = 580;
    
    //desenhando fundo da sacola
    draw_sprite_ext(spr_sacola, 1, _x, _y, _escala, _escala, 0, c_white, 1);
    
    //texto de peso
    var _peso_atual = string(global.peso_atual / 1000);
    var _peso_max = string(global.peso_max / 1000) + "kg";
    draw_text(_x - 120, _y + 80, _peso_atual + "/" + _peso_max);
    
    //adicionando minerio de acordo com o peso
    var _porc = (peso_atual / global.peso_max) * 100;
    var _index = 0;
    
    //configurando porcentagem
    if (_porc > 0 && _porc < 20)         _index = 2;
    else if (_porc >= 20 && _porc < 40)  _index = 3;
    else if (_porc >= 40 && _porc < 60)  _index = 4;
    else if (_porc >= 60 && _porc < 80)  _index = 5;
    else if (_porc >= 80 && _porc < 100) _index = 6;
    else if (_porc >= 100)               _index = 7;
    
    //desenhando os drops caindo
    desenha_drop(_x, _y);
    
    //desenhando os minerios no saquinho
    draw_sprite_ext(spr_sacola, _index, _x, _y, _escala, _escala, 0, c_white, 1);
    
    //desenhando frente da sacola
    draw_sprite_ext(spr_sacola, 0, _x, _y, _escala, _escala, 0, c_white, 1);
    
    show_debug_message(_porc);
}

//desenhando a moeda
desenha_moeda = function()
{
    //não desenha a moeda na mina
    if (room == rm_mina) exit;
    
    //variaveis pro draw
    var _escala = 5;
    var _x = 60;
    var _y = 60;
    
    //desenhando moedas
    frame = draw_animation(frame, spr_moeda);
    draw_sprite_ext(spr_moeda, frame, _x, _y, _escala, _escala, 0, c_white, 1);
    
    //texto da moeda
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    
    draw_text(_x + 80, _y, global.moeda);
    
    draw_set_halign(-1);
    draw_set_valign(-1);
}

//desenhando o drop caindo na sacola
desenha_drop = function(_xsacola, _ysacola)
{
    //rodando a lista de tras pra frente pra poder deletar mais facil
    for (var i = array_length(itens_caindo) - 1; i >= 0; i--)
    {
        var _item = itens_caindo[i];
        
        var _escala = 5;
        
        //aplicando velocidade
        _item.vspd += .2;
        _item.y += _item.vspd;
        
        //desenhando a sprite
        draw_sprite_ext(spr_drops_sacola, _item.frame, _xsacola, _item.y, _escala, _escala, 0, c_white, 1);
        
        //apagando se chegou na sacola
        if (_item.y >= _ysacola)
        {
            peso_atual += _item.peso;
            array_delete(itens_caindo, i, 1);
        }
    }
}