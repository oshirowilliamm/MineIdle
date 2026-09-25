event_inherited();


y_notificacao = y + 12;

pode_comprar = function()
{
    //verificando se o player tem dinheiro o suficiente para comprar algum upgrade
    var _chaves = struct_get_names(global.upgrades);
    
    for (var i = 0; i < array_length(_chaves); i++)
    {
        var _upgrade = global.upgrades[$ _chaves[i]];
        
        //checando se n esta no level maximo
        if (_upgrade.level_atual < _upgrade.level_max)
        {
            //checando se tenho dinheiro
            if (global.dados.moeda >= _upgrade.get_custo())
            {
                return true;
            }
        }
    }
    
    return false;
}