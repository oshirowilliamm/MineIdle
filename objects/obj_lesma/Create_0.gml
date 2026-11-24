image_speed = 0;
boca_aberta = false;
tempo_boca = 10;
timer_boca = 0;




abrindo_boca = function()
{
    //abrindo a boca
    if (boca_aberta)
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
            image_speed = 0;
            image_index = 0;
        }
    }
}

