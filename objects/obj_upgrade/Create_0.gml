//upgrade selecionado
upgrade = 0;

//variavel de controle pra mostrar as infos
infos = false;

//escala de desenho
escala = 2;

//frame de animação da moeda
frame_moeda = 0;

//pegando a posição central da grid
margem = 20;
tamanho = (32 * escala) + margem;
xcentro = (display_get_gui_width() / 2) - margem / 2;
ycentro = (display_get_gui_height() / 2) - margem / 2;

desenha_botoes = function()
{
    //pegando a quantidade de upgrades
    var _chaves = struct_get_names(global.upgrades);
    infos = false;
    
    //rodando os upgrades
    for (var i = 0; i < array_length(_chaves); i++)
    {
        //pegando o tipo dos upgrades
        var _upgrade = global.upgrades[$ _chaves[i]];

        //posição do upgrade em grid
        var _x = xcentro + (_upgrade.coluna * tamanho);
        var _y = ycentro + (_upgrade.linha * tamanho);   
        
        //desenhando os botões
        draw_sprite_ext(spr_upgrade, _upgrade.index, _x, _y, escala, escala, 0, c_white, 1);
        
        //clicando nos botões
        var _mx = device_mouse_x_to_gui(0);
        var _my = device_mouse_y_to_gui(0);
        var _x2 = _x - 32 * escala;
        var _y2 = _y - 32 * escala;
        var _rectangle = point_in_rectangle(_mx, _my, _x2, _y2, _x, _y);
        
        if (_rectangle)
        {
            //habilitando as infos
            infos = true;
            
            //guardando o upgrade selecionado
            upgrade = _upgrade;
            
            //comprando
            comprando();
        }
    }
}

desenha_infos = function()
{
    if (!infos) exit;
    
    //margem
    var _margem = 20;
    
    //infos do botão de upgrade
    var _wbotao = sprite_get_width(spr_upgrade) * escala;
    var _hbotao = sprite_get_height(spr_upgrade) * escala;
    var _xbotao = xcentro + (upgrade.coluna * tamanho) - (_wbotao / 2);
    var _ybotao = ycentro + (upgrade.linha * tamanho) - (_hbotao / 2);

    /////////////// FUNDO ///////////////
    //largura do fundo
    var _wfundo = 500 + _margem;
    
    //altura da descrição
    var _htxt = string_height(upgrade.descricao);
    var _htxt_ext = string_height_ext(upgrade.descricao, _htxt, _wfundo - _margem) * .8;
    
    //altura do fundo
    var _hnome = string_height(upgrade.nome);
    var _hcusto = string_height(string(upgrade.custo_inicial)) * 1.5;
    var _espaco = 20; //entre os itens
    var _hfundo = _margem + (_hnome / 2) + _espaco + _htxt_ext + _espaco + _hcusto + _margem;
    
    //posição do fundo
    var _xfundo = _xbotao - _wfundo / 2;
    var _yfundo = _ybotao - _hfundo - _hbotao / 2;
    
    //desenhando fundo
    draw_sprite_stretched(spr_fundo, 0, _xfundo, _yfundo, _wfundo, _hfundo);
    
    
    
    /////////////// NOME ///////////////
    //posição
    var _xnome = _xfundo + _wfundo / 2;
    var _ynome = _yfundo + _margem;
    
    //texto
    draw_text(_xnome, _ynome, upgrade.nome);
    
    //desenhando a linha de divisória
    var _ylinha = _ynome + _hnome / 2 + _espaco / 2;
    draw_sprite_stretched(spr_linha, 0, _xfundo, _ylinha, _wfundo, 1);
    
    
    
    /////////////// DESCRIÇÃO ///////////////
    //posição
    var _xtxt = _xnome;
    var _ytxt = _ylinha + _htxt_ext / 2 + _espaco / 2;
    
    //texto da descricao
    draw_text_ext_transformed(_xtxt, _ytxt, upgrade.descricao, _htxt, _wfundo - _margem, .8, .8, 0);
    
    //desenhando a linha de divisória
    var _ylinha2 = _ytxt + _htxt_ext / 2 + _espaco / 2
    draw_sprite_stretched(spr_linha, 0, _xfundo, _ylinha2, _wfundo, 1);
    
    
    
    /////////////// VALOR DO UPGRADE ///////////////
    //posição
    var _xvenda = _xtxt + 25;
    var _yvenda = _ylinha2 + _hcusto / 2 + _espaco / 2;
    
    //texto do custo
    draw_set_colour(c_yellow);
    draw_text_transformed(_xvenda, _yvenda, upgrade.custo_inicial, 1.5, 1.5, 0);
    draw_set_colour(c_white);
    
    
    
    /////////////// MOEDA ///////////////
    var _xmoeda = _xvenda - string_width(upgrade.custo_inicial) - 25;
    var _ymoeda = _yvenda;
    frame_moeda = draw_animation(frame_moeda, spr_moeda);
    
    draw_sprite_ext(spr_moeda, frame_moeda, _xmoeda, _ymoeda, 4, 4, 0, c_white, 1);
}

comprando = function()
{
    if (mouse_check_button_pressed(mb_left))
    {
        //calculando custo de acordo com o nivel do upgrade
        var _custo = floor(upgrade.custo_inicial * power(upgrade.custo_aumento, upgrade.level - 1));
        
        //aplicando upgrade
        if (global.moeda >= _custo && upgrade.level < upgrade.level_max)
        {
            //tirando dinheiro
            global.moeda -= _custo;
            
            //aumenta nivel
            upgrade.level++;
            
            //efeito
            upgrade.efeito(upgrade.level);
            
            show_debug_message(upgrade.level);
        }
    }
}