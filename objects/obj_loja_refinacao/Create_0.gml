// Inherit the parent event
event_inherited();

custo = 50;



desenha_loja = function()
{
    draw_self();
    
    //loja bloqueada
    if (global.refinacao_bloqueada)
    {
        scribble_anim_wave(2, .1, .05);
        
        //sombra
        draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_black, .9);
        
        //pegando o valor do custo e da pedra atual
        var _dados = global.minerios[$ global.pedra_atual];
        var _pedra_atual = global.inventario_global.minerios[$ global.pedra_atual] ?? 0;
        
        //mudando a cor de acordo com as pedras q tenho
        var _cor_pedra = (_pedra_atual >= custo)
            ? "[cor_positivo]"
            : "[cor_negativo]";
        
        var _y = y - 80;
        
        //sprite da pedra
        var _sprite = string("[wave][scale, 10][{0},{1}][/]", spr_minerios, _dados.sprite);
        texto_scribble(x, _y, _sprite, .1, .1, 1, 1);
        
        //texto do custo
        var _texto  = string("[wave]{2}{1}[/c] / {0}[/wave]", custo, _pedra_atual, _cor_pedra);
        texto_scribble(x, _y + 20, _texto, .1, .1, 1, 1);
    }
}

desbloqueia = function()
{
    //desbloqueando
    global.refinacao_bloqueada = false;
    
    //gastando a pedra
    global.inventario_global.minerios[$ global.pedra_atual] -= custo;
}

estado = function()
{
    if (global.refinacao_bloqueada)
    {
        var _pedra_atual = global.inventario_global.minerios[$ global.pedra_atual] ?? 0;
        
        //se eu tenho pedras pra comprar
        if (_pedra_atual >= custo)
        {
            tecla_interacao(x, y_origem, desbloqueia);
        }
    }
    else
    {
        tecla_interacao(x, y_origem, entra_loja);
    }
}