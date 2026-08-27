//posição inicial da primeira colunas
#macro X_INICIAL 256
#macro Y_INICIAL 79

//colunas e linhas
#macro MAX_COLUNAS 50 
#macro MAX_LINHAS 8

//margem de visualização dos blocos
#macro MARGEM 2 

//tamanho do bloco
#macro BLOCO_WIDTH  32
#macro BLOCO_HEIGHT 32

//inicializando o blocos pos
global.blocos_struct = array_create(MAX_COLUNAS);

for (var i = 0; i < MAX_COLUNAS; i++)
{
    global.blocos_struct[i] = array_create(MAX_LINHAS, undefined);
}





//metodos
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

gera_colunas = function(_col)
{
    for (var i = 0; i < MAX_LINHAS; i++)
    {
        //posição dos blocos
        var _x = X_INICIAL + (_col * BLOCO_WIDTH);
        var _y = Y_INICIAL + (i * BLOCO_HEIGHT);
        
        //se o bloco ja foi criado, n faz nada
        if (position_meeting(_x, _y, obj_minerio)) continue;
        
        //se o bloco foi quebrado, n faz nada
        var _estado = global.blocos_struct[_col][i];
        
        if (_estado == "vazio") continue;
        
        //adicionando o bloco na estrutura
        if (_estado == undefined)
        {
            _estado = gera_tipo_blocos();
            global.blocos_struct[_col][i] = _estado;
        }
        
        //criando o bloco
        var _bloco = instance_create_layer(_x, _y, layer, obj_minerio, {tipo_bloco: _estado});
    }
}

gera_tipo_blocos = function()
{
    //var _chaves = struct_get_names(global.minerios);
    //var _index = irandom(array_length(_chaves) - 1);
       //
    //return _chaves[_index];
    
    var _room = room_get_name(room);
    
    //verificando o bioma que minha sala pertence
    if (variable_struct_exists(global.biomas, _room))
    {
        var _bioma = global.biomas[$ _room];
        var _blocos = _bioma.minerios;
        
        //somando as chances de todos os blocos
        var _chances = 0;
        for (var i = 0; i < array_length(_blocos); i++)
        {
            _chances += _blocos[i].chance;
        }
        
        //sorteando um numero
        var _sorteio = irandom(_chances - 1);
        var _acumulado = 0;
        
        //verificando o bloco sorteado
        for (var i = 0; i < array_length(_blocos); i++)
        {
            _acumulado += _blocos[i].chance;
            
            if (_sorteio <= _acumulado)
            {
                return _blocos[i].nome;
            }
        }
    }
    
    //retorno de segurança
    return "b1_pedra";
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