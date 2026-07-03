//itens
global.inventario = 
[
    {nome: "Pedra",     valor: 1,  quantidade: 0, peso: 200},
    {nome: "Roxo",      valor: 2,  quantidade: 0, peso: 400},
    {nome: "Verde",     valor: 5,  quantidade: 0, peso: 600},
    {nome: "Azul",      valor: 5,  quantidade: 0, peso: 800},
    {nome: "Amarelo",   valor: 20, quantidade: 0, peso: 1000}
];

//picareta
global.picareta = 
{
    dano: 5,
    cooldown: 15
};

//upgrades
global.upgrades = 
{
    //classe 1 - dano
    dano:
    [
        //0
        {
            nome: "Dano da Picareta",
            descricao: "Aumenta o dano da picareta em 10%", 
            custo: 20,
            efeito: function()
            {
                global.picareta.dano += global.picareta.dano * .1;
            },
            //posição
            coluna: 0,
            linha: 0
        }
    ],
    //classe 2 - stamina
    stamina:
    [
        //0
        {
            nome: "Stamina",
            descricao: "Aumenta a stamina em 50%", 
            custo: 10,
            efeito: function()
            {
                global.stamina_max += global.stamina_max * .5;
            },
            //posição
            coluna: 1,
            linha: 0
        }
    ],
    //classe 3 - capacidade
    capacidade:
    [
        //0
        {
            nome: "Capacidade",
            descricao: "Aumenta a capacidade da bolsa de minérios em 50%", 
            custo: 30,
            efeito: function()
            {
                global.peso_max += global.peso_max * .5;
            },
            //posição
            coluna: 0,
            linha: 1
        }
    ]
};