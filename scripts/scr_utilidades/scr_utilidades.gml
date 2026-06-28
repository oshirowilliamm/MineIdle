//deixando jogo aleatorio
randomise();

//sombra
function desenha_sombra(_scale = .5)
{
	//garatindo que o y sempre esteja no pe
	var _y = y - sprite_yoffset + sprite_height; 
	draw_sprite_ext(spr_sombra, 0, x, _y, _scale, _scale, 0, c_white, .25);
}

//seleção
function selecao()
{
    if (position_meeting(mouse_x, mouse_y, id))
    {
        image_index = 1;
    }
    else
    {
        image_index = 0;
    }
}

//infos de loja
function info_loja(_valor)
{
    draw_set_font(fnt_itens);
    draw_set_halign(fa_center);
    
    //variaveis do mouse
    var _x = device_mouse_x_to_gui(0);
    var _y = device_mouse_y_to_gui(0);
    
    //margem do fundo
    var _margem = 40;
    
    //largura do fundo
    var _wnome = string_width(texto);
    var _wvenda = string_width(_valor) + sprite_get_width(spr_moeda);
    var _wfundo = max(_wnome, _wvenda) + _margem;
    
    //altura do fundo
    var _hnome = string_height(texto);
    var _hvenda = max(string_height(_valor), sprite_get_height(spr_moeda));
    var _espaco = 20; //espaço entre nome e venda
    var _hfundo = _hnome + _hvenda + _espaco + _margem;
    
    //posição do fundo
    var _xfundo = _x;
    var _yfundo = _y - _hfundo;
    
    //desenhando fundo
    draw_sprite_stretched(spr_fundo, 0, _xfundo, _yfundo, _wfundo, _hfundo);
    
    //variaveis das infos
    var _xnome = _xfundo + _wfundo / 2;
    var _ynome = _yfundo + _margem / 2;
    var _xvenda = _xnome + 10;
    var _yvenda = _ynome + _hnome + _espaco;
    
    //nome
    draw_text(_xnome, _ynome, texto);
    //venda
    draw_set_colour(c_lime);
    draw_text(_xvenda, _yvenda, _valor);
    draw_set_colour(c_white);
    //moeda
    var _xmoeda = _xvenda - string_width(_valor) - 18;
    draw_sprite(spr_moeda, 0, _xmoeda, _yvenda);
    
    draw_set_halign(-1);
    draw_set_font(-1);
}