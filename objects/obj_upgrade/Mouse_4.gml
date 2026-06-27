if (global.moeda >= custo)
{
    //deixando picareta mais forte
    global.picareta.dano += 1;
    
    //tirando o dinheiro
    global.moeda -= custo;
}    