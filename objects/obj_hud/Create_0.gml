debug = false;
frame = 0;

//desenhando a barra de stamina
desenha_stamina = function()
{
    //desenha stamina só na mina
    if (room != rm_mina) exit;
    
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
    //desenhando frente da sacola
    draw_sprite_ext(spr_sacola, 0, _x, _y, _escala, _escala, 0, c_white, 1);
    
    //texto de peso
    var _peso_atual = string(global.peso_atual / 1000);
    var _peso_max = string(global.peso_max / 1000) + "kg";
    draw_text(_x - 120, _y + 80, _peso_atual + "/" + _peso_max);
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