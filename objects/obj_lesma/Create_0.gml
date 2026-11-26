escala = 5;
estado = noone;

//variavel da posição da lesma
x_lesma = display_get_gui_width() / 2;
y_lesma = display_get_gui_height() / 2 + 300;
y_boca = y_lesma - 450;

//variavel da animação da boca
boca_aberta = false;
tempo_boca = 12;
timer_boca = 0; 




parada = function()
{
    sprite_index = spr_lesma_parada;
    image_speed = 1;
    
    //indo pro estado de abrindo a boca
    if (boca_aberta)
    {
        estado = abrindo_boca;
        image_index = 0;
    }
}

abrindo_boca = function()
{
    sprite_index = spr_lesma_abrindo_boca;  
    
    if (timer_boca > 0) timer_boca--;
    
    //deixando a boca aberta
    if (boca_aberta || instance_exists(obj_minerio_boca))
    {
        timer_boca = tempo_boca;
    }
    
    //abrindo a boca
    if (timer_boca > 0)
    {
        //animação ate a boca abrir
        image_speed = 1.5;
        
        if (image_index > 5)
        {
            image_index = 5;
        }
    }
    //fechando a boca
    else
    {
        image_speed = -1;
        
        if (image_index <= 1) 
        {
            estado = parada;
        }
    }
}

cagando = function()
{
    
}

estado = parada;