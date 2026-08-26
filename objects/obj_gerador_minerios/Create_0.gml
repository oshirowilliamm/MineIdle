linhas  = 8;
colunas = 100;

x_inicial = 256;
y_inicial = 64;

//variaveis do bloco
bloco_width = sprite_get_width(spr_minerios_blocos);
bloco_height = sprite_get_height(spr_minerios_blocos);




gerador = function()
{
    for (var i = 0; i < linhas; i++)
    {
        for (var j = 0; j < colunas; j++)
        {
            var _x = x_inicial + (j * bloco_width);
            var _y = y_inicial + (i * bloco_height);
            instance_create_layer(_x, _y, layer, obj_minerio);
        }
    }
}

gerador();


#region DEBUG
    
    define_room_width = function()
    {
        room_width = x_inicial + (colunas * bloco_width) + 64;
    }
    
    desenha_numero_blocos = function()
    {
        for (var i = 0; i < linhas; i++)
        {
            for (var j = 0; j < colunas; j++)
            {
                var _x = x_inicial + (j * bloco_width);
                var _y = y_inicial + (i * bloco_height);
                
                draw_text(_x, _y, j);
            }
        }
    }
    
#endregion