//efeitos
escala = new efeito_escala();
scribble_anim_wave(2, .1, .1);
y_atual = y;





alimentando = function()
{
    //pegando as infos da receita
    var _receita       = pega_receita(obj_prato.item, obj_prato.categoria);
    var _pedra_atual   = global.inventario_global.minerios[$ global.pedra_atual];
    var _minerio_atual = global.inventario_global[$ obj_prato.categoria][$ obj_prato.item];
    
    if (_pedra_atual == undefined) _pedra_atual = 0;
    if (_minerio_atual == undefined) _minerio_atual = 0;
    
    //se tem os itens necessários
    if (_pedra_atual >= _receita.custo_pedras && _minerio_atual >= _receita.custo_minerio)
    {
        //tirando a pedra do inventario
        global.inventario_global.minerios[$ global.pedra_atual] -= _receita.custo_pedras;
        
        //tirando o minerio do inventario
        global.inventario_global[$ obj_prato.categoria][$ obj_prato.item] -= _receita.custo_minerio;
        
        //adicionando o resultado
        if (global.inventario_global[$ _receita.categoria_resultado][$ _receita.resultado] == undefined)
        {
            global.inventario_global[$ _receita.categoria_resultado][$ _receita.resultado] = 0;
        }
        
        global.inventario_global[$ _receita.categoria_resultado][$ _receita.resultado]++;
        
        //limpando o prato
        if (global.inventario_global[$ obj_prato.categoria][$ obj_prato.item] < _receita.custo_minerio)
        {
            obj_prato.desenho = false;
        }
    }
}

selecao = function()
{
    var _mouse_sobre = position_meeting(mouse_x, mouse_y, id);
    var _mouse_click = mouse_check_button_pressed(mb_left);
    
    if (_mouse_sobre && obj_prato.desenho)
    {
        y_atual = lerp(y_atual, ystart + 10, .1);
        
        //quando clicar, alimenta
        if (_mouse_click)
        {
            alimentando();
        }
    }
    else
    {
        y_atual = lerp(y_atual, ystart, .1);
    }
}

desenha_feed = function()
{
    var _y = y_atual + 5;
    
    if (obj_prato.desenho)
    {
        scribble_anim_shake(.5, .1);
        var _xscale = .15 * escala.xscale;
        var _yscale = .15 * escala.yscale;
        
        //pegando as infos da receita
        var _receita       = pega_receita(obj_prato.item, obj_prato.categoria);
        var _pedra_atual   = global.inventario_global.minerios[$ global.pedra_atual];
        var _minerio_atual = global.inventario_global[$ obj_prato.categoria][$ obj_prato.item];
        
        //se tem os itens necessários
        if (_pedra_atual >= _receita.custo_pedras && _minerio_atual >= _receita.custo_minerio)
        {
            var _texto = "[wave][shake]FEED[/]";
            texto_scribble(x, _y, _texto, _xscale, _yscale, 1, 1, cor_positivo);
        }
        //se n tem pedras necessárias
        else
        {
            var _texto = "[shake]FEED[/]";
            texto_scribble(x, _y, _texto, _xscale, _yscale, 1, 1, cor_negativo);
        }
    }
    else
    {
        var _xscale = .12 * escala.xscale;
        var _yscale = .12 * escala.yscale;
        
        var _texto = "FEED";
        texto_scribble(x, _y, _texto, _xscale, _yscale, 1, 1, c_gray, .7);
    }
}