//se o gerador n passou o tipo_bloco, coloca o padrão como a pedra 1
if (!variable_instance_exists(id, "tipo_bloco")) tipo_bloco = "pedra1";

//pegando os dados do bloco
var _dados = global.minerios[$ tipo_bloco];

//definindo a sprite
image_index = _dados.sprite;

//vida
vida = _dados.vida;
max_vida = _dados.vida;

//tempo pra regeneração
tempo = 5 * FPS;
timer = tempo;



descarrega_bloco = function()
{
    //informações da camera
    var _vx = camera_get_view_x(view_camera[0]);
    var _vw = camera_get_view_width(view_camera[0]);
    
    //pegando inicio e fim da camera
    var _margem = sprite_width * 2;
    var _inicio = _vx - _margem;
    var _fim    = _vx + _vw + _margem;
    
    //se ficar fora da camera, se destroi
    if (x < _inicio || x > _fim)
    {
        instance_destroy();
    }
}

recebe_dano = function(_dano)
{
    //morrendo
    if (vida <= 0)
    {
        instance_destroy();
        toca_som(snd_bloco_destruindo);
        
        //mudando o estado na struct
        var _col   = floor((x - X_INICIAL) / sprite_width);
        var _linha = floor((y - Y_INICIAL) / sprite_height);
        
        global.blocos_struct[_col][_linha] = "vazio";
    }
    //tomando dano
    else
    {
        vida -= _dano;
        toca_som(snd_hit_bloco, .4);
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
    draw_sprite(spr_rachaduras, _index, x, y);
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