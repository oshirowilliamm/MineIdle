//mina
global.mina = noone;

//itens
global.itens = {};
global.itens[BLOCOS.terra] =    {nome: "terra",     valor: 1, quantidade: 0};
global.itens[BLOCOS.pedra] =    {nome: "pedra",     valor: 2, quantidade: 0};
global.itens[BLOCOS.ferro] =    {nome: "ferro",     valor: 5, quantidade: 0};
global.itens[BLOCOS.ouro] =     {nome: "ouro",      valor: 5, quantidade: 0};
global.itens[BLOCOS.ametista] = {nome: "ametista",  valor: 20, quantidade: 0};

//dinheiro
global.moeda = 0;

//picareta
global.picareta = 
{
    dano: 1,
    cooldown: 15
};

//interface
global.interface = false;