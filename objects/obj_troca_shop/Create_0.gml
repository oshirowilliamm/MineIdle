image_index = index;



mostra_nome = function()
{
    var _mouse_sobre = position_meeting(mouse_x, mouse_y, id);
    
    if (_mouse_sobre)
    {
        texto_scribble(x - sprite_width / 2, y, texto, 1,, 2, 1);
    }
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
            cria_transicao(destino, sq_transicao_1_loja, sq_transicao_2_loja);
        }
    }
    //normal
    else
    {
        tween_scale(1.5, tween_animation.back, 30);
    }
}