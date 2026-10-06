event_inherited();


y_notificacao = y + 12;

custo = 100;



desenha_loja = function()
{
    draw_self();
    
    //loja bloqueada
    if (global.upgrades_bloqueado)
    {
        scribble_anim_wave(2, .1, .05);
        
        //sombra
        draw_sprite_ext(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, c_black, .9);
        
        //mudando a cor de acordo com o dinheiro q tenho
        var _cor = (global.dados.moeda >= custo)
            ? "[cor_positivo]"
            : "[cor_negativo]";
        
        var _y = y - 40;
        
        //sprite da moeda
        var _sprite = string("[wave][scale, 15][{0}][/]", spr_moeda);
        texto_scribble(x, _y, _sprite, .1, .1, 1, 1);
        
        //texto do custo
        var _texto  = string("[wave]{2}{1}[/c] / {0}[/wave]", custo, global.dados.moeda, _cor);
        texto_scribble(x, _y + 20, _texto, .1, .1, 1, 1);
    }
}

desbloqueia = function()
{
    //desbloqueando
    global.upgrades_bloqueado = false;
    
    //gastando dinheiro
    global.dados.moeda -= custo;
}

estado = function()
{
    if (global.upgrades_bloqueado)
    {
        //se eu tenho dinheiro suficiente
        if (global.dados.moeda >= custo)
        {
            tecla_interacao(x, y_origem, desbloqueia);
        }
    }
    else
    {
        tecla_interacao(x, y_origem, entra_loja);
    }
}

mostra_notificacao = function()
{
    if (global.upgrades_bloqueado) return;
    
    //verificando se o player tem dinheiro o suficiente para comprar algum upgrade
    var _chaves = struct_get_names(global.upgrades);
    
    for (var i = 0; i < array_length(_chaves); i++)
    {
        var _upgrade = global.upgrades[$ _chaves[i]];
        
        //checando se n esta no level maximo
        if (_upgrade.level_atual < _upgrade.level_max)
        {
            //checando se tenho dinheiro
            if (global.dados.moeda >= _upgrade.get_custo())
            {
                return true;
            }
        }
    }
    
    return false;
}