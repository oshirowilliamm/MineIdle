//deixando jogo aleatorio
randomise();

//debugs
function debugs()
{
    if (!DEV_MODE) exit;
    
    //segura o ctrl
    if (!keyboard_check(vk_lcontrol)) exit;
    
    //// CHEATS ////
    
    //ganhando dinheiro
    if (keyboard_check_pressed(ord("G")))
    {
        global.moeda += 100;
        show_debug_message("DEBUG: +100 Moedas (Total: " + string(global.moeda) + ")");
    }
    
    //reiniciando jogo
    if (keyboard_check_pressed(ord("R")))
    {
        show_debug_message("DEBUG: Reiniciando Jogo...");
        game_restart();
    }
    
    //ganhando todos os itens
    if (keyboard_check_pressed(ord("I")))
    {
        for (var i = 0; i < array_length(global.inventario.minerio); i++)
        {
            global.inventario.minerio[i].quantidade++;
            global.inventario.minerio[i].descoberto = true;
        }
        for (var i = 0; i < array_length(global.inventario.refinado); i++)
        {
            global.inventario.refinado[i].quantidade++;
            global.inventario.refinado[i].descoberto = true;
        }
        show_debug_message("DEBUG: +1 de todos os itens concedido.");
    }
    
    //ganhando minerios um por um
    static item_minerio = -1;
    if (keyboard_check_pressed(vk_up))
    {
        item_minerio = (item_minerio + 1) % array_length(global.inventario.minerio);
        global.inventario.minerio[item_minerio].quantidade++;
        global.inventario.minerio[item_minerio].descoberto = true;
        show_debug_message("DEBUG: +1 Minério (ID: " + string(item_minerio) + ")");
    }
    
    //ganhando refinados um por um
    static item_refinado = -1;
    if (keyboard_check_pressed(vk_down))
    {
        item_refinado = (item_refinado + 1) % array_length(global.inventario.refinado);
        global.inventario.refinado[item_refinado].quantidade++;
        global.inventario.refinado[item_refinado].descoberto = true;
        show_debug_message("DEBUG: +1 Refinado (ID: " + string(item_refinado) + ")");
    }
    
    // ganha o primeiro refinado
    if (keyboard_check_pressed(vk_right))
    {
        global.inventario.refinado[0].quantidade++;
        global.inventario.refinado[0].descoberto = true;
        show_debug_message("DEBUG: +1 Refinado Index 0");
    }
    
    //mostrando linha de mineração
    if (keyboard_check_pressed(ord("L")))
    {
        debug_linha = !debug_linha;
        show_debug_message("DEBUG: Linha de mineração " + (debug_linha ? "ON" : "OFF"));
    }
    
    //aumentando spd do player
    if (keyboard_check_pressed(ord("V")))
    {
        debug_spd = !debug_spd;
        spd = debug_spd ? 20 : spd_max;
        show_debug_message("DEBUG: Super Velocidade " + (debug_spd ? "ON" : "OFF"));
    }
    
    //noclip
    if (keyboard_check_pressed(ord("N")))
    {
        debug_noclip = !debug_noclip;
        colisores = debug_noclip ? [] : [tile_bordas, tile_minerios, tile_bordas_inicio];
        show_debug_message("DEBUG: Noclip " + (debug_noclip ? "ON" : "OFF"));
    }
    
    //ganha luz
    if (keyboard_check_pressed(ord("B")))
    {
        global.alcance_lanterna += global.alcance_lanterna * .1;
        show_debug_message("DEBUG: Luz aumentada em 10%");
    }
}

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

//animação em draw_sprite
function draw_animation(_frame, _sprite)
{
    //velocidade de acordo com o editor
    var _spd = sprite_get_speed(_sprite) / game_get_speed(gamespeed_fps);
    
    //adicionando frames
    _frame += _spd;
    
    //zerando se passar do numero de frames do sprite
    if (_frame >= sprite_get_number(_sprite))
    {
        return 0
    }   
    
    return _frame
}




