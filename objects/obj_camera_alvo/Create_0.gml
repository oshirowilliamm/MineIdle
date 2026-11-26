altura = 30;

posiciona = function()
{
    if (instance_exists(obj_player))
    {
        x = obj_player.x;
        y = obj_player.y - altura;
    }
}

posiciona();