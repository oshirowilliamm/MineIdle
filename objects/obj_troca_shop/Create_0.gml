shop = ["venda", "picareta"];
atual = 0;




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