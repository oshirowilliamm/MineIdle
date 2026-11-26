image_xscale = 0;
image_yscale = image_xscale;
image_alpha = 0;

y_efeito = 0;
y_dest = 45;
estado = noone;



comeco = function()
{
    //aparacendo
    image_alpha = lerp(image_alpha, .9, .05);
    
    //movimento
    if (instance_exists(obj_player))
    {
        //efeito no y
        y_efeito = lerp(y_efeito, y_dest, .1);
        
        //seguindo o player
        x = obj_player.x;
        y = obj_player.y - y_efeito;
    }
    
    //pop
    image_xscale = lerp(image_xscale, 1.5, .1);
    image_yscale = image_xscale;
}

fim = function()
{
    //desaparacendo
    image_alpha = lerp(image_alpha, 0, .1);
    
    //movimento
    if (instance_exists(obj_player))
    {
        //efeito no y
        y_efeito = lerp(y_efeito, 0, .1);
        
        //seguindo o player
        x = obj_player.x;
        y = obj_player.y - y_efeito;
    }
    
    //despop
    image_xscale = lerp(image_xscale, 0, .1);
    image_yscale = image_xscale;
    
    //destruindo
    if (image_alpha <= .5) instance_destroy();
}


estado = comeco;