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
    var _xlimpo     = _xbruto + 130;
    var _yinicial   = display_get_gui_height() / 2 - 370;
    
    var _pagina = global.paginas_livro[pagina_atual];
    
    //desenhando todos os minerios
    for (var i = 0; i < array_length(_pagina); i++)
    {
        //tirando a pedra
        if (string_pos("_pedra", _pagina[i]) == 0)
        {
            //definindo o y
            var _yatual = _yinicial + (i * 140);
            
            //////// BRUTOS /////////
            var _item_bruto = _pagina[i];
            
            var _infos = {item: _item_bruto, categoria: "minerios", sprite: spr_minerios};
            instance_create_depth(_xbruto, _yatual, -9999, obj_minerio_inv, _infos);
            
            //////// LIMPOS /////////
            var _item_limpo = _item_bruto + "_limpo";
            
            _infos = {item: _item_limpo, categoria: "limpos", sprite: spr_limpos};
            instance_create_depth(_xlimpo, _yatual, -9999, obj_minerio_inv, _infos);
        }
    }
    
    pagina_criada = true;
}
