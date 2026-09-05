inicia_efeito_squash();

escala = global.escala_hud;
pagina_atual = 0;

//controle para criar a pagina somente uma vez
pagina_criada = false;




cria_minerios = function()
{
    if (pagina_atual == 0)
    {
        var _x = 75;
        var _y = display_get_gui_height() / 2 - 370;
        
        var _pagina = global.paginas_livro[pagina_atual];
        
        //desenhando os minerios
        for (var i = 0; i < array_length(_pagina); i++)
        {
            var _item = _pagina[i];
            
            //tirando a pedra
            if (string_pos("_pedra", _item) == 0)
            {
                //definindo o y
                var _yatual = _y + (i * 150);
                
                //criando o item
                var _infos = {item: _item, categoria: "minerios", sprite: spr_minerios};
                instance_create_depth(_x, _yatual, -9999, obj_minerio_inv, _infos);
            }
        }
    }
}

cria_pagina = function()
{
    if (pagina_criada) return;
    
    cria_minerios();
    
    pagina_criada = true;
}
