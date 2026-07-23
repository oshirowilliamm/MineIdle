cor_texto = c_green;
frame_moeda = 0;


//comprando
comprando_upgrade = function()
{
    //se tem dinheiro pra comprar
    if (global.moeda >= upgrade.custo_inicial)
    {
        //diminuindo dinheiro
        global.moeda -= upgrade.custo_inicial;
        
        //aumentando level
        if (upgrade.level < upgrade.level_max) upgrade.level++;
        
        //falando que comprou
        return true;
    }
    else
    {
        return false;
    }
}

//desbloqueia os proximos upgrades
desbloqueia_upgrade = function(_compra)
{
    //se eu consegui comprar, pode desbloquar os outros
    if (_compra)
    {
        //checando quantos alvos eu tenho
        var _qtd = array_length(upgrade.alvos);
        
        //so vou fazer alguma coisa se eu tiver alvos
        if (_qtd > 0)
        {
            for (var i = 0; i < _qtd; i++)
            {
                var _atual = upgrade.alvos[i];
                
                //desbloqueando o alvo
                if (_atual.upgrade.desbloqueado == false)
                {
                    _atual.upgrade.desbloqueado = true;
                }
            }
        }
    }
}

//desenhando as infos do upgrade
desenha_infos = function()
{
    
}