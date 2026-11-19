scribble_anim_wave(2, .1, .1);

image_index = index;
escala = 3;
escala_botao = new efeito_escala();

//dados da picareta
picareta = global.tipos_picareta[index];
status = "";

//variaveis de posição
x_dest = 110;
y_pedestal = y;
pos = 0;

//variavel do efeito y
onda = false;

//variavel de efeito do botão
botao_efx = 0;




status_picareta = function()
{
    if (picareta.comprada)
    {
        status = "comprada";
    }
    else if (index == obj_carrossel_picareta.proxima())
    {
        status = "proxima";
    }
    else
    {
        status = "bloqueada";
    }
}

posicao = function()
{
    //indo pro lugar certo
    var _carrossel = obj_carrossel_picareta;
    pos = index - _carrossel.vendo;
    var _lugar = _carrossel.centro + pos * _carrossel.espaco;
    
    x = lerp(x, _lugar, .1);
    
    //ajustando y
    if (pos == 0)
    {
        y = lerp(y, ystart - 50, .1);
        y_pedestal = lerp(y_pedestal, ystart - 20, .1);
    }
    else
    {
        y = lerp(y, ystart, .1);
        y_pedestal = lerp(y_pedestal, ystart, .1);
    }
}

efeito_y = function()
{
    var _dest = ystart - 20
    
    if (!onda)
    {
        //subindo a picareta
        y = lerp(y, _dest, .1);
        
        //quando terminar de subir, avisar a onda
        if (abs(y - _dest) <= .5) onda = true;
    }
    else    
    {
        //efeito de onda
        var _sinwave = 6 * sin(2 * current_time / 1000);
        y = lerp(y, _dest + _sinwave, .1);
    }
}   

selecao = function()
{
    var _mouse_sobre = position_meeting(mouse_x, mouse_y, id);
    
    if (_mouse_sobre)
    {
        //mouse segurando o botão
        if (global.mouse_hold)
        {
            tween_scale(escala - .2, tween_animation.flat, 30);
        }
        //mouse em cima
        else
        {
            //efeito
            tween_scale(escala + .5, tween_animation.back, 30);
            y = lerp(y, ystart - 30, .1);
        }
        
        //clicando
        if (global.mouse_released)
        {
            //mandando a picareta pro centro
            obj_carrossel_picareta.vendo = index;
        }  
    }   
    //normal
    else
    {
        tween_scale(escala, tween_animation.back, 30);
        y = lerp(y, ystart, .1);
        
        onda = false;
        infos = false;
    }
}

me_desenhando = function()
{
    switch (status) 
    {
        case "comprada":
            draw_self();
        break;
        
        case "proxima":
            draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_gray, image_alpha);
        break;                                                 
        
        case "bloqueada":                                     
            shader_set(sh_muda_cor);
            draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_black, image_alpha);
            shader_reset();
        break;  
    }
}

botao_comprar = function(_y)
{
    //variaveis base
    var _wcaixa = 250 * escala_botao.xscale;
    var _hcaixa = 80 * escala_botao.yscale;
    var _xcaixa = display_get_gui_width() / 2 - _wcaixa / 2;
    var _ystart = _y;
    _y += botao_efx;
    
    //interação
    var _mx = device_mouse_x_to_gui(0);
    var _my = device_mouse_y_to_gui(0);
    var _mouse_sobre = point_in_rectangle(_mx, _my, _xcaixa, _ystart, _xcaixa + _wcaixa, _ystart + _hcaixa);
    
    if (_mouse_sobre)
    {
        botao_efx = lerp(botao_efx, -30, .1);
        escala_botao.atualiza(2);
    }
    else
    {
        botao_efx = lerp(botao_efx, 0, .1);
        escala_botao.retorna();
    }
    
    //desenhando a caixa
    draw_sprite_stretched(spr_botao_comprar, 0, _xcaixa, _ystart + botao_efx, _wcaixa, _hcaixa);
    
    var _x = _xcaixa + _wcaixa / 2;
    _y += 40;
    
    //se a picareta ja foi adquirida
    if (picareta.comprada)
    {
        //se esta equipada
        if (global.nivel_picareta == index)
        {
            var _texto = string("[wave][c_gray]EQUIPADA[/]");
            texto_scribble(_x, _y, _texto, 2,, 1, 1);
        }
        //se n ta equipada
        else
        {
            var _texto = string("[wave][c_gray]EQUIPAR[/]");
            texto_scribble(_x, _y, _texto, 2,, 1, 1);
        }
    }
    //se a picareta não foi adquirida
    else
    {
        var _texto = string("[wave][c_gray]COMPRAR: ${0}[/]", picareta.preco);
        texto_scribble(_x, _y, _texto, 2,, 1, 1);
    }
}

mostra_info = function()
{
    if (pos == 0 && status != "bloqueada")
    {
        var _wcaixa = 800;
        var _hcaixa = 300;
        var _xcaixa = display_get_gui_width() / 2 - _wcaixa / 2;
        var _y = display_get_gui_height() / 2 - _hcaixa - 120;
        var _yfundo = _y + _hcaixa;
        
        draw_sprite_stretched(spr_caixa_gui, 0, _xcaixa, _y, _wcaixa, _hcaixa);
        
        //nome
        var _xnome = _xcaixa + _wcaixa / 2;
        var _texto = string("[rainbow]{0}[/]", picareta.nome);
        texto_scribble(_xnome, _y, _texto, 3,, 1, 1);
        
        //dano
        _y += 70;
        _texto = string("Dano: {0}", picareta.dano);
        texto_scribble(_xnome, _y, _texto, 2,, 1, 1);
        
        //cooldown
        _y += 50;
        _texto = string("Cooldown: {0}", picareta.cooldown);
        texto_scribble(_xnome, _y, _texto, 2,, 1, 1);
        
        botao_comprar(_yfundo - 120);
    }
}