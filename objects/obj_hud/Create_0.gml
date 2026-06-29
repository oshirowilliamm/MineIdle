debug = false;
hud = true;

//desenhando a barra de stamina
desenha_stamina = function()
{
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
}

//desenhando a sacola que guarda os itens
desenha_sacola = function()
{
    //variaveis pro draw
    var _escala = 5;
    var _x1 = display_get_gui_width() - 80;
    var _y1 = 580;
    
    //desenhando fundo da sacola
    draw_sprite_ext(spr_sacola, 1, _x1, _y1, _escala, _escala, 0, c_white, 1);
    //desenhando frente da sacola
    draw_sprite_ext(spr_sacola, 0, _x1, _y1, _escala, _escala, 0, c_white, 1);
}