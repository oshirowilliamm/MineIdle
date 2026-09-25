//começa invisivel
visible = false;

//vendo quem é o dono
dono = noone;

//cooldown da picareta
cooldown_atual = 0;

//controles para o bloco e o seletor
bloco = noone;
seletor = noone;


//metodos auxiliares
segue_player = function()
{
    if (instance_exists(dono))
    {
        x = dono.x;
        y = dono.yy;
        
        //fica na frente do player
        depth = dono.depth - 1;
    }
}

define_sprite = function()
{
    if (instance_exists(dono))
    {
        if (visible)
        {
            //espelhando igual o dono
            image_xscale = dono.dir;
            
            //mudando a sprite de acordo com a direção
            switch (dono.direcao)
            {
                //direita
                case 0:
                    sprite_index = spr_picareta_side;
                    x = dono.x - 10;
                    y = dono.yy - 6;
                break;
                
                //cima
                case 1:
                    sprite_index = spr_picareta_back;
                    x = dono.x + 3;
                    y = dono.yy - 11;
                break;
                
                //esquerda
                case 2: 
                    sprite_index = spr_picareta_side;
                    x = dono.x + 10;
                    y = dono.yy - 6;
                break;
                
                //baixo
                case 3:
                    sprite_index = spr_picareta_front;
                    x = dono.x + 1;
                    y = dono.yy - 18;
                break;
            }
        }
    }
}

linha_mineracao = function()
{
    //pegando a distancia da linha
    var _dist = 30; 
    var _dir = point_direction(dono.x, dono.yy, mouse_x, mouse_y);
    
    //pegando a posição da linha
    var _x = dono.x + lengthdir_x(_dist, _dir);
    var _y = dono.yy + lengthdir_y(_dist, _dir);
    
    //se tem um bloco na minha visão
    var _bloco = instance_position(_x, _y, obj_minerio);
    
    //avisando se tem um bloco na minha visao ou nao
    if (_bloco)
    {
        bloco = _bloco;
    }
    else
    {
        bloco = noone;
    }
}



//metodos de mineração
inicia_golpe = function()
{
    visible = true;
}

encerra_golpe = function()
{
    visible = false;
}

aplica_golpe = function()
{
    if (global.dados.stamina_atual > 0)
    {
        //dando dano
        if (bloco)
        {
            var _dano = global.picareta.dano;
            var _critico = false;
            
            //calculando o dano critico se tiver
            if (random(100) < global.dados.chance_critico)
            {
                _dano += global.picareta.dano * 2;
                _critico = true;
                toca_som(snd_critico, .1);
            }
            
            //aplicando dano e tirando stamina
            bloco.recebe_dano(_dano, _critico);
            global.dados.stamina_atual -= bloco.custo_stamina;
        }
        
        //aplicando o cooldown
        cooldown_atual = global.picareta.cooldown;
    }
}



//metodos de selecao
meu_seletor = function()
{
    //se existe o bloco
    if (instance_exists(bloco))
    {
        //criando o seletor
        if (!instance_exists(seletor))
        {
            seletor = instance_create_depth(bloco.x, bloco.y, obj_player.depth + 1, obj_seletor);
        }
        
        //atualizando a posição do seletor
        seletor.x = bloco.x;
        seletor.y = bloco.y;
    }
    //se n tem bloco na minha visao
    else
    {
        //destruindo o seletor
        if (instance_exists(seletor))
        {
            instance_destroy(seletor);
        }
    }
}