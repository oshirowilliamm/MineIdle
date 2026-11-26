event_inherited();

escala = 5;
estado = noone;

//variaveis para o entrar_refinacao
botao_voltar = noone;

//variavel da animação da boca
boca_aberta = false;
tempo_boca = 12;
timer_boca = 0; 







entra_refinacao = function()
{
    //desativando player
    obj_player.estado = obj_player.estado_desativado;
    
    //desativando a tecla de interação
    acao = noone;
    
    //avisando que a refinação está aberta
    global.refinacao_aberta = true;
    
    //criando o voltar
    if (!instance_exists(obj_botao_voltar))
    {
        var _voltar = instance_create_layer(0, 0, "HUD", obj_botao_voltar);
        _voltar.lesma = true;
    }
}

sai_refinacao = function()
{
    obj_player.estado = obj_player.estado_parado;
    acao = entra_refinacao;
    global.refinacao_aberta = false;
}

//estados
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



//definindo estado
estado = parada;

//definindo acao
acao = entra_refinacao;