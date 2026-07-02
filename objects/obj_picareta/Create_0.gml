//variavel para checar se pode golpear
pode_golpear = true;
//variavel pra checar se esta usando a picareta
usando = false;
//tempo do efeito
tempo = 0;

//picaretando
golpe = function()
{
    //validação com o player
    if (!instance_exists(obj_player)) exit
    
    //variaveis do efeito
    var _angle, _xscale, _yscale;
    
    //espelhando efeito de acordo com a direção da picareta
    switch (obj_player.dir) 
    {
        //direita
        case 0:
            _angle = 270;
            _yscale = 1;
        break;
        //cima
        case 1:
            _angle = 180;
            _yscale = -1;
        break;
        //esquerda
        case 2:
            _angle = 270;
            _yscale = -1;
        break;
        //baixo
        case 3:
            _angle = 180;
            _yscale = 1;
        break;
    } 
    
    //se pode golpear
    if (pode_golpear)
    {
        //tempo passando
        tempo++;
        
        //efeito da picareta atacando
        image_angle = _angle;
        image_yscale = _yscale;
        image_index = 1;
    }
    
    //chamando o codigo de minerar bloco no meio da animação
    if (tempo == 5)
    {
        //pegando a linha de mineração
        var _linha = linha_mineracao();
        
        //chamando o minera bloco
        global.mina.minera_bloco(_linha.x, _linha.y, global.picareta.dano);
    }
    
    //quando chegar no tempo limite do efeito, reseta tudo
    if (tempo >= 10)
    {
        //parando o efeito de golpear
        pode_golpear = false;
        //resetando tempo
        tempo = 0;
        
        //resetando efeito
        image_angle = 0;
        image_yscale = 1;
        image_index = 0;
    }
    //quando o tempo do efeito resetar, pode golpear novamente
    else
    {
    	pode_golpear = true;
    }
    
    //retornando o valor do pode golpear para resetar o golpe
    return pode_golpear;
}

//função para pegar a linha de mineração    
linha_mineracao = function()
{
    //validação da existência do player
    if(!instance_exists(obj_player)) exit;
    
    //distancia do lengthdir
    var _dist = 36;
    
    //pegando a direção da linha de acordo com a direção do player
    switch (obj_player.dir) 
    {
        //cima
        case 1:
            _dist -= 5;
        break;
        //baixo
        case 3:
            _dist += 7;
        break;
    } 
    
    //pegando direção do player pro mouse
    var _dir = point_direction(obj_player.x, obj_player.yy, mouse_x, mouse_y);
    
    //traça uma linha de visão do player com a distancia de 32 pixels e direção do mouse
    var _x = obj_player.x + lengthdir_x(_dist, _dir);
    var _y = obj_player.yy + lengthdir_y(_dist, _dir);
    
    //retornando as posições da linha
    return
    {
        x: _x,
        y: _y
    };
}