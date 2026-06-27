//aplicando upgrade
if (global.moeda >= upgrade.custo)
{
    //tirando dinheiro
    global.moeda -= upgrade.custo;
    
    //efeito
    upgrade.efeito();
}