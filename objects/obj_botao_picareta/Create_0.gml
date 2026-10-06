shop = ["venda", "picareta"];
atual = 0;




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
        var _y = 212;
        var _espaco = 200;
        
        for (var i = 0; i < 3; i++)
        {
        	var _picaretas = instance_create_layer(_x + (i * _espaco), _y, "Itens", obj_shop_picareta);
            _picaretas.index = i;
        }
    }
}

muda_shop = function()
{
    //mudando o icone
    image_index = !image_index;
    
    //mudando o shop
    if (atual < 1)
    {
        atual++;
    }
    else
    {
        atual = 0;
    }
    
    global.shop = shop[atual];
    
    atualiza_picaretas();
}

selecao = function()
{
    var _mouse_sobre = position_meeting(mouse_x, mouse_y, id);
    
    if (_mouse_sobre)
    {
        if (global.mouse_hold)
        {
            //mouse segurando o botão
            tween_scale(1.2, tween_animation.flat, 30);
        }
        else
        {
            //mouse em cima
            tween_scale(2, tween_animation.back, 30);
        }
        
        //clicando
        if (global.mouse_released)
        {
            muda_shop();
        }
    }
    //normal
    else
    {
        tween_scale(1.5, tween_animation.back, 30);
    }
}