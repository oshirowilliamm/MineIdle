centro = room_width / 2;
y_picaretas = 235;
espaco = 200;
vendo = global.nivel_picareta;



proxima = function()
{
    //pegando a proxima picareta depois da comprada
    for (var i = 0; i < array_length(global.tipos_picareta); i++)
    {
        if (!global.tipos_picareta[i].comprada) return i;
    }
    
    return -1; //todas foram compradas
}

cria_picaretas = function()
{
    //destruindo as picaretas
    if (instance_exists(obj_shop_picareta))
    {
        instance_destroy(obj_shop_picareta);
    }
    
    //criando as picaretas
    for (var i = 0; i < array_length(global.tipos_picareta); i++)
    {
        var _x = centro * (i - vendo) * espaco;
        
        instance_create_layer(_x, y_picaretas, "Itens", obj_shop_picareta, {index: i});
    }
}

cria_picaretas();