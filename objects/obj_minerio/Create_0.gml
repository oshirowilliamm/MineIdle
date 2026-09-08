depth = -y;

//efeitos
inicia_efeito_squash();
inicia_efeito_brilho();
brilho = noone;

//se o gerador n passou o tipo_bloco, coloca o padrão como a pedra 1
if (!variable_instance_exists(id, "tipo_bloco")) tipo_bloco = "pedra1";

//pegando os dados do bloco
dados = global.minerios[$ tipo_bloco];

//definindo a sprite
image_index = dados.sprite;

//vida
vida = dados.vida;
max_vida = dados.vida;
custo_stamina = dados.stamina;

//tempo pra regeneração
tempo = 5 * FPS;
timer = tempo;




descarrega_bloco = function()
{
    //informações da camera
    var _vx = camera_get_view_x(view_camera[0]);
    var _vw = camera_get_view_width(view_camera[0]);
    
    //pegando inicio e fim da camera
    var _margem = BLOCO_WIDTH * 2;
    var _inicio = _vx - _margem;
    var _fim    = _vx + _vw + _margem;
    
    //se ficar fora da camera, se destroi
    if (x < _inicio || x > _fim)
    {
        instance_destroy();
    }
}

cria_drop = function(_minerio)
{
    //infos pra mandar pro drop
    var _infos =
    {
        index: dados.sprite,
        tipo: tipo_bloco
    }
    
    var _qtd = 1;
    
    //verificando a chance de dropar mais de um
    if (random(100) < global.chance_drop)
    {
        _qtd += 1;
        toca_som(snd_drop_duplo, .2);
    }
    
    //criando o drop
    repeat (_qtd) 
    {
    	instance_create_layer(x, y, "Drops", obj_drop, _infos);
    }
}

recebe_dano = function(_dano)
{
    //se tiver dano, executa o dano
    if (_dano > 0)
    {
        if (vida > 0)
        {
            vida -= _dano;
            timer = tempo;
            
            //efeitos
            if (vida > 0)
            {
                toca_som(snd_hit_bloco, .4);
                screenshake(2);
                efeito_squash(.8, .8);
                aplica_efeito_brilho();
            }
        }
    }
    //se n tiver dano
    else
    {
        toca_som(snd_hit_bloco_errado, .2);
    }
}

morre = function()
{
    if (vida <= 0)
    {
        instance_destroy();
        
        //efeitos
        toca_som(snd_bloco_destruindo);
        screenshake(5);
        
        //mudando o estado na struct
        var _col   = floor((x - X_INICIAL) / BLOCO_WIDTH);
        var _linha = floor((y - Y_INICIAL) / BLOCO_HEIGHT);
        
        global.blocos_struct[_col][_linha] = "vazio";
        
        //dropando item
        cria_drop(tipo_bloco);
    }
}

regenera_vida = function()
{
    //se a vida estiver cheia, n faz nada
    if (vida >= max_vida) return;
    
    //abaixando o timer
    if (timer > 0) timer--;
    
    //quando o tempo terminar, regenera a vida
    if (timer <= 0)
    {
        vida = max_vida;
        timer = tempo;
    }
}



desenha_rachaduras = function()
{
    //se a vida tiver cheia, n faz nada
    if (vida >= max_vida) return false;
    
    //dividindo a vida em porcentagem
    var _porc = (vida / max_vida) * 100;
    var _1 = 80, _2 = 60, _3 = 40, _4 = 20;
    
    //desenhando quebrado de acordo com a vida do bloco
    var _index = 0;
    
    if (_porc <= 100 && _porc > _1)     _index = 0; //100% da vida
    else if (_porc <= _1 && _porc > _2) _index = 1; //80% da vida
    else if (_porc <= _2 && _porc > _3) _index = 2; //60% da vida
    else if (_porc <= _3 && _porc > _4) _index = 3; //40% da vida
    else if (_porc <= _4)               _index = 4; //20% da vida
    
    //desenhando as rachaduras
    draw_sprite_ext(spr_rachaduras, _index, x, y, xscale, yscale, 0, c_white, 1);
}

