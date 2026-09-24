//começa invisivel
visible = false;

//vendo quem é o dono
dono = noone;

//cooldown da picareta
cooldown_atual = 0;



//metodos
linha_mineracao = function()
{
    var _dist = 30; //distancia da linha
    var _dir = point_direction(dono.x, dono.yy, mouse_x, mouse_y);
    
    var _x = dono.x + lengthdir_x(_dist, _dir);
    var _y = dono.yy + lengthdir_y(_dist, _dir);
    
    return
    {
        x: _x,
        y: _y
    }
}

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
        //pegando a linha de mineração
        var _linha = linha_mineracao();
        
        //se tem um bloco na minha visão
        var _bloco = instance_position(_linha.x, _linha.y, obj_minerio);
        
        //dando dano
        if (_bloco)
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
            _bloco.recebe_dano(_dano, _critico);
            global.dados.stamina_atual -= _bloco.custo_stamina;
        }
        
        //aplicando o cooldown
        cooldown_atual = global.picareta.cooldown;
    }
}