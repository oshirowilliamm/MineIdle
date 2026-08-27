//posição inicial da primeira colunas
#macro X_INICIAL 256
#macro Y_INICIAL 64

//colunas e linhas
#macro MAX_COLUNAS 100 
#macro MAX_LINHAS 8 

//margem de visualização dos blocos
#macro MARGEM 2 

//variaveis do bloco
bloco_width  = sprite_get_width(spr_minerios_blocos);
bloco_height = sprite_get_height(spr_minerios_blocos);

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
    var _inicio = floor((_vx - X_INICIAL) / bloco_width) - MARGEM;
    var _fim    = ceil(((_vx + _vw) - X_INICIAL) / bloco_width) + MARGEM;
    
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
        var _x = X_INICIAL + (_col * bloco_width);
        var _y = Y_INICIAL + (i * bloco_height);
        
        //se o bloco ja foi criado, n faz nada
        if (position_meeting(_x, _y, obj_minerio)) continue;
        
        //se o bloco foi quebrado, n faz nada
        var _estado = global.blocos_struct[_col][i];
        
        if (_estado == "vazio") continue;
        
        //adicionando o bloco na estrutura
        if (_estado == undefined)
        {
            _estado = "pedra1";
            global.blocos_struct[_col][i] = _estado;
        }
        
        //criando o bloco
        var _bloco = instance_create_layer(_x, _y, layer, obj_minerio, {tipo_bloco: _estado});
    }
}

gera_tipo_blocos = function()
{
    
}



#region DEBUG
    
    desenha_numero_struct = function()
    {
        //informações da camera
        var _vx = camera_get_view_x(view_camera[0]);
        var _vw = camera_get_view_width(view_camera[0]);
        
        //pegando colunas iniciais de finais
        var _margem = 2;
        var _inicio = floor((_vx - X_INICIAL) / bloco_width) - _margem;
        var _fim    = ceil(((_vx + _vw) - X_INICIAL) / bloco_width) + _margem;
        
        //travando as colunas
        _inicio = max(0, _inicio);
        _fim    = min(MAX_COLUNAS - 1, _fim);
        
        //gerando as colunas no range
        for (var i = _inicio; i <= _fim; i++)
        {
            var _x = X_INICIAL + (i * bloco_width);
            
            for (var j = 0; j < MAX_LINHAS; j++)
            {
                var _y = Y_INICIAL + (j * bloco_height);
                
                var _texto = string(global.blocos_struct[i][j]);
                
                draw_text_transformed(_x, _y, _texto, .5, .5, 0);
            }
        }
    }
    
#endregion