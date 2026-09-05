inicia_efeito_squash();

escala = global.escala_hud;
pagina_atual = 0;

//controle para criar a pagina somente uma vez
pagina_criada = false;



cria_pagina = function()
{
    if (pagina_criada) return;
    
    //posição dos minerios
    var _xbruto     = 75;
    var _xpuro     = _xbruto + 130;
    var _xrefinado  = _xpuro + 130;
    var _yinicial   = display_get_gui_height() / 2 - 370;
    
    var _pagina = global.paginas_livro[pagina_atual];
    
    //desenhando todos os minerios
    for (var i = 0; i < array_length(_pagina); i++)
    {
        var _item = _pagina[i];
        
        //tirando a pedra
        if (string_pos("_pedra", _item) == 0)
        {
            //definindo o y
            var _yatual = _yinicial + (i * 140);
            
            //////// BRUTOS /////////
            var _infos = {item: _item, categoria: "minerios", sprite: spr_minerios};
            instance_create_depth(_xbruto, _yatual, -9999, obj_minerio_inv, _infos);
            
            //////// puroS /////////
            var _item_puro = _item + "_puro";
            
            _infos = {item: _item_puro, categoria: "puros", sprite: spr_puros};
            instance_create_depth(_xpuro, _yatual, -9999, obj_minerio_inv, _infos);
            
            //////// REFINADOS /////////
            var _item_refinado = _item + "_refinado";
            
            _infos = {item: _item_refinado, categoria: "refinados", sprite: spr_refinados};
            instance_create_depth(_xrefinado, _yatual, -9999, obj_minerio_inv, _infos);
        }
        //salvando a pedra do bioma atual
        else
        {
            global.pedra_atual = _item;
        }
    }
    
    pagina_criada = true;
}
