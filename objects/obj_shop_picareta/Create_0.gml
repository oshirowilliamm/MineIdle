index = 0;
escala = 4;

x_dest = 110;
y_inicial = y;
mostra_infos = false;

image_index = index;




desenha_infos = function()
{
    if (!mostra_infos) return;
    
    var _picareta = global.tipos_picareta[index];
    
    var _nome = _picareta.nome;
    texto_scribble(x, y, _nome);
}

selecao = function()
{
    var _mouse_sobre = position_meeting(mouse_x, mouse_y, id);
    
    if (_mouse_sobre)
    {
        //mouse segurando o botão
        if (global.mouse_hold)
        {
            tween_scale(escala - .2, tween_animation.flat, 30);
        }
        //mouse em cima
        else
        {
            tween_scale(escala + 1, tween_animation.bounce, 30);
            y = lerp(y, ystart - 30, .1);
            mostra_infos = true;
        }
        
        //clicando
        if (global.mouse_released)
        {
            
        }
    }
    //normal
    else
    {
        tween_scale(escala, tween_animation.back, 30);
        y = lerp(y, ystart, .1);
        mostra_infos = false;
    }
}