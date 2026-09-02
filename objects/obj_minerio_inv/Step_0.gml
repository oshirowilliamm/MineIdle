EM_TRANSICAO

segue_inventario();
selecao();

if (shake)
{
    //diminuindo o timer
    shake_timer--;
    
    //efeito de tremer
    if (shake_timer > 0)
    {
        shake_x = dsin(shake_timer * 50) * 3;
    }
    //resetando o shake
    else
    {
        shake_timer = 10;
        shake = false;
        shake_x = 0;
    }
}