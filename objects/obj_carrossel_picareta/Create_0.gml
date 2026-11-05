atualiza_picaretas = function()
{
    //destruindo as picaretas
    if (instance_exists(obj_shop_picareta))
    {
        instance_destroy(obj_shop_picareta);
    }
    
    //criando as picaretas
    if (global.shop == "picareta")
    {
        var _x = 110;
        var _y = 222;
        var _espaco = 200;
        
        for (var i = 0; i < 3; i++)
        {
        	var _picaretas = instance_create_layer(_x + (i * _espaco), _y, "Itens", obj_shop_picareta);
            _picaretas.index = i;
        }
    }
}