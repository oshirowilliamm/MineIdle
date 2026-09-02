//posição inicial da primeira colunas
#macro X_INICIAL 336
#macro Y_INICIAL 79

//colunas e linhas
#macro MAX_COLUNAS 100 
#macro MAX_LINHAS 12

//margem de visualização dos blocos
#macro MARGEM 2 

//tamanho do bloco
#macro BLOCO_WIDTH  32
#macro BLOCO_HEIGHT 32

//inicializando o a struct dos blocos
global.blocos_struct = array_create(MAX_COLUNAS);
for (var i = 0; i < MAX_COLUNAS; i++)
{
    global.blocos_struct[i] = array_create(MAX_LINHAS, undefined);
}





//metodos
minerios_veias = function(_col, _linha)
{
    //pegando os vizinhos
    var _vizinho_esq  = (_col > 0) ? global.blocos_struct[_col - 1][_linha] : undefined;
    var _vizinho_cima = (_linha > 0) ? global.blocos_struct[_col][_linha - 1] : undefined;
    
    //se o minerio da esquerda for do mesmo tipo, copia ele
    if (_vizinho_esq != undefined && _vizinho_esq != "vazio" && string_pos("_pedra", _vizinho_esq) == 0)
    {
        if (random(99) < 20) return _vizinho_esq;
    }
    
    //se o minerio de cima for do mesmo tipo, copia ele
    if (_vizinho_cima != undefined && _vizinho_cima != "vazio" && string_pos("_pedra", _vizinho_cima) == 0)
    {
        if (random(99) < 20) return _vizinho_cima;
    }
    
    //se n encontrou nada
    return undefined;
}

calcula_chance_minerio = function(_nome, _chance_base, _profundidade, _col)
{
    //se for pedra
    if (string_pos("_pedra", _nome) != 0)
    {
        //perde chance quanto mais profundo
        return max(10, _chance_base - (_profundidade * 40))
    }
    
    //se for cristal
    if (string_pos("_cristal", _nome) != 0)
    {
        //ganha chance
        return _chance_base + (_profundidade * (_chance_base * 6));
    }
    
    //se for rocha
    if (string_pos("_rocha", _nome) != 0)
    {
        if (_col < MAX_COLUNAS / 2)
        {
            //ganha chance
            return _chance_base + (_profundidade * (_chance_base * 3));
        }
        else
        {
            //perde chance quanto mais profundo
            var _chance_atual = _chance_base + (.5 * (_chance_base * 3));
            var _profundidade_atual = _profundidade * .5;
            
            return max(2, _chance_atual - (_profundidade_atual * 40));
        }
        
    }
}

sorteia_minerio = function(_blocos, _chances_blocos, _chances_totais)
{
    //sorteando um numero
    var _sorteio = random(_chances_totais);
    var _acumulado = 0;
    
    //verificando o bloco sorteado
    for (var i = 0; i < array_length(_blocos); i++)
    {
        _acumulado += _chances_blocos[i];
        
        if (_sorteio < _acumulado)
        {
            return _blocos[i].nome;
        }
    }
    
    //retorno de segurança (bloco de pedra do bioma)
    return _blocos[0].nome;
}

gera_tipo_blocos = function(_col, _linha)
{
    var _room = room_get_name(room);
    
    //verificando o bioma que minha sala pertence
    if (variable_struct_exists(global.biomas, _room))
    {
        //fazendo veias de minerios
        var _veia = minerios_veias(_col, _linha);
        if (_veia != undefined) return _veia;
        
        //pegando os blocos do bioma
        var _bioma = global.biomas[$ _room];
        var _blocos = _bioma.minerios;
        
        //fator de profundidade
        var _profundidade = _col / max(1, MAX_COLUNAS - 1);
        
        //variaveis para as chances de cada minerio
        var _chances_totais = 0;
        var _chances_blocos  = array_create(array_length(_blocos));
        
        //calculando os pesos de cada bloco
        for (var i = 0; i < array_length(_blocos); i++)
        {
            var _atual  = _blocos[i];
            var _camada = _atual.camada;
            
            if (_col >= _camada)
            {
                var _peso = calcula_chance_minerio(_atual.nome, _atual.chance, _profundidade, _col);
                _chances_blocos[i] = _peso;
                _chances_totais   += _peso;
            }
        }
        
        //retornando o sorteio do bloco
        return sorteia_minerio(_blocos, _chances_blocos, _chances_totais);
    }
}

gera_blocos = function(_col, _linha)
{
    //posição dos blocos
    var _x = X_INICIAL + (_col * BLOCO_WIDTH);
    var _y = Y_INICIAL + (_linha * BLOCO_HEIGHT);
    
    //se o bloco ja foi criado, n faz nada
    if (position_meeting(_x, _y, obj_minerio)) return;
    
    //se o bloco foi quebrado, n faz nada
    var _estado = global.blocos_struct[_col][_linha];
    if (_estado == "vazio") return;
    
    //adicionando o bloco na estrutura
    if (_estado == undefined)
    {
        //escolhendo o tipo do bloco
        _estado = gera_tipo_blocos(_col, _linha);
        
        //adicionando ele na estrutura
        global.blocos_struct[_col][_linha] = _estado;
    }
    
    //criando o bloco
    instance_create_layer(_x, _y, layer, obj_minerio, {tipo_bloco: _estado});
}

gera_colunas = function(_col)
{
    for (var i = 0; i < MAX_LINHAS; i++)
    {
        gera_blocos(_col, i);
    }
}

atualiza_blocos_visiveis = function()
{
    //informações da camera
    var _vx = camera_get_view_x(view_camera[0]);
    var _vw = camera_get_view_width(view_camera[0]);
    
    //pegando colunas iniciais de finai
    var _inicio = floor((_vx - X_INICIAL) / BLOCO_WIDTH) - MARGEM;
    var _fim    = ceil(((_vx + _vw) - X_INICIAL) / BLOCO_WIDTH) + MARGEM;
    
    //travando as colunas
    _inicio = max(0, _inicio);
    _fim    = min(MAX_COLUNAS - 1, _fim);
    
    //gerando as colunas no range
    for (var i = _inicio; i <= _fim; i++)
    {
        gera_colunas(i)
    }
}





#region DEBUG
    
    desenha_numero_struct = function()
    {
        //informações da camera
        var _vx = camera_get_view_x(view_camera[0]);
        var _vw = camera_get_view_width(view_camera[0]);
        
        //pegando colunas iniciais de finais
        var _margem = 2;
        var _inicio = floor((_vx - X_INICIAL) / BLOCO_WIDTH) - _margem;
        var _fim    = ceil(((_vx + _vw) - X_INICIAL) / BLOCO_WIDTH) + _margem;
        
        //travando as colunas
        _inicio = max(0, _inicio);
        _fim    = min(MAX_COLUNAS - 1, _fim);
        
        //gerando as colunas no range
        for (var i = _inicio; i <= _fim; i++)
        {
            var _x = X_INICIAL + (i * BLOCO_WIDTH);
            
            for (var j = 0; j < MAX_LINHAS; j++)
            {
                var _y = Y_INICIAL + (j * BLOCO_HEIGHT);
                
                var _texto = string(global.blocos_struct[i][j]);
                
                draw_text_transformed(_x, _y, _texto, .5, .5, 0);
            }
        }
    }
    
#endregion