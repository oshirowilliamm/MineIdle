




desenha_quantidade = function(_receita)
{
    var _pedra   = global.minerios[$ global.pedra_atual];
    var _minerio = obj_prato.minerio;
    var _pedra_atual   = global.inventario_global.minerios[$ global.pedra_atual];
    var _minerio_atual = global.inventario_global[$ obj_prato.categoria][$ obj_prato.item];
    
    //pegando as cores
    var _cor_minerio = (_minerio_atual >= _receita.custo_minerio)
        ? "[cor_positivo]"
        : "[cor_negativo]";
    
    var _cor_pedra = (_pedra_atual >= _receita.custo_pedras)
        ? "[cor_positivo]"
        : "[cor_negativo]";
    
    //desenhando custo de minerio
    var _xitem = x + 20;
    var _yminerio = y + 30;
    
    var _sprite = string("[scale, 10][{0},{1}][/]", obj_prato.sprite, _minerio.sprite);
    _texto  = string("{2} {3}{1}[/] / {0}", _receita.custo_minerio, _minerio_atual, _sprite, _cor_minerio);
    texto_scribble(_xitem, _yminerio, _texto, .1, .1,, 1);
    
    //desenhando custo de pedra
    var _ypedra = _yminerio + 30;
    
    _sprite = string("[scale, 10][{0},{1}][/]", spr_minerios, _pedra.sprite);
    _texto  = string("{2} {3}{1}[/] / {0}", _receita.custo_pedras, _pedra_atual, _sprite, _cor_pedra);
    texto_scribble(_xitem, _ypedra, _texto, .1, .1,, 1);
}

desenha_sprite_resultado = function(_x, _y, _receita)
{
    var _spr_resultado = spr_puros;
    
    if (string_pos("_puro", _receita.resultado) != 0)
    {
        _spr_resultado = spr_puros;
    }
    else if (string_pos("_refinado", _receita.resultado) != 0)
    {
        _spr_resultado = spr_refinados;
    }
    
    var _texto = string("[scale, 20][{0},{1}][/]", _spr_resultado, global.minerios[$ _receita.resultado].sprite);
    texto_scribble(_x, _y, _texto, .1, .1, 1, 1, c_black);
    texto_scribble(_x, _y + 5, "???", .1, .1, 1);
}

desenha_receita = function()
{
    scribble_anim_wave(3, .1, .05);
    
    var _receita = pega_receita(obj_prato.item, obj_prato.categoria);
    
    if (_receita != undefined)
    {
        //nome do resultado
        var _x = x + sprite_width / 2;
        var _texto = string("[wave][rainbow]{0}[/]", global.minerios[$ _receita.resultado].nome);
        texto_scribble(_x, y, _texto, .1, .1, 1, 1);
        
        //quantidade do minerio e da pedra
        desenha_quantidade(_receita);
        
        //sprite do resultado
        desenha_sprite_resultado(_x, y + 100, _receita);
    }
}