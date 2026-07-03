//upgrade selecionado
upgrade = 0;

//variavel de controle pra mostrar as infos
infos = false;

//escala de desenho
escala = 4;

//frame de animação da moeda
frame_moeda = 0;

desenha_botoes = function()
{
    //pegando a posição central da grid
    var _margem = 50;
    var _tamanho = (32 * escala) + _margem;
    var _xcentro = (display_get_gui_width() / 2) - _margem / 2;
    var _ycentro = (display_get_gui_height() / 2) - _margem / 2;
    
    //pegando a categoria dos upgrades
    var _categoria = struct_get_names(global.upgrades);
    infos = false;
    
    //rodando as categorias de upgrades
    for (var i = 0; i < array_length(_categoria); i++)
    {
        //pegando o tipo dos upgrades
        var _tipo = global.upgrades[$ _categoria[i]];
        
        //rodando tipos de upgrades
        for (var j = 0; j < array_length(_tipo); j++)
        {
            //upgrade
            var _upgrade = _tipo[j];
            
            //posição do upgrade em grid
            var _x = _xcentro + (_upgrade.coluna * _tamanho);
            var _y = _ycentro + (_upgrade.linha * _tamanho);   
            
            //desenhando os botões
            draw_sprite_ext(spr_upgrade, 0, _x, _y, escala, escala, 0, c_white, 1);
            
            //clicando nos botões
            var _mx = device_mouse_x_to_gui(0);
            var _my = device_mouse_y_to_gui(0);
            var _x2 = _x - 32 * escala;
            var _y2 = _y - 32 * escala;
            var _rectangle = point_in_rectangle(_mx, _my, _x2, _y2, _x, _y);
            
            if (_rectangle)
            {
                infos = true;
                upgrade = _upgrade;
            }
        }
    }
}

desenha_infos = function()
{
    if (!infos) exit;
    
    //valor do upgrade
    var _valor = string(upgrade.custo);
    
    var _margem = 50;
    
    //largura do fundo
    var _wfundo = 300 + _margem;
    
    //altura do fundo
    var _espaco = 20; //espaço entre nome e venda
    var _hfundo = 100 + _margem;
    
    //posição do fundo
    var _xfundo = sprite_get_width(spr_item) - 32;
    var _yfundo = sprite_get_height(spr_item) - 32;
    
    //desenhando fundo
    draw_sprite_stretched(spr_fundo, 0, _xfundo, _yfundo, _wfundo, _hfundo);
    
    /////////////// DESCRIÇÃO ///////////////
    var _xnome = _xfundo + _wfundo / 2;
    var _ynome = _yfundo + _margem / 2;
    var _hnome = string_height(upgrade.descricao);
    
    draw_text_ext(_xnome, _ynome, upgrade.descricao, _hnome, _wfundo);
    
    /////////////// VALOR DO UPGRADE ///////////////
    var _xvenda = _xnome + 10;
    var _yvenda = _ynome + _hnome + _espaco;
    
    draw_set_colour(c_lime);
    draw_text(_xvenda, _yvenda, _valor);
    draw_set_colour(c_white);
    
    /////////////// MOEDA ///////////////
    var _xmoeda = _xvenda - string_width(_valor) - 15;
    var _ymoeda = _yvenda + 15;
    var _escala = 3;
    frame_moeda = draw_animation(frame_moeda, spr_moeda);
    
    draw_sprite_ext(spr_moeda, frame_moeda, _xmoeda, _ymoeda, _escala, _escala, 0, c_white, 1);
}