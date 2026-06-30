//mina
global.mina = noone;
global.chunks = {};
global.bloco_defs = {};
global.chance_spawn_total = 0;

//dinheiro
global.moeda = 0;

//stamina
global.stamina_max = 100;
global.stamina_atual = global.stamina_max;
global.stamina_dano = 2;

//itens
global.inventario_max = 10000;
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
            descricao: "Aumenta o dano \nda picareta \nem 10%", 
            custo: 20,
            efeito: function()
            {
                global.picareta.dano += global.picareta.dano * .1;
            }
        }
    ],
    //classe 2 - stamina
    stamina:
    [
        //0
        {
            descricao: "Aumenta a \nstamina em 50%", 
            custo: 10,
            efeito: function()
            {
                global.stamina_max += global.stamina_max * .5;
            }
        }
    ]
};
