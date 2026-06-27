//mina
global.mina = noone;

//itens
global.itens = 
[
    {nome: "terra",    valor: 1,  quantidade: 0},
    {nome: "pedra",    valor: 2,  quantidade: 0}, 
    {nome: "ferro",    valor: 5,  quantidade: 0}, 
    {nome: "ouro",     valor: 5,  quantidade: 0}, 
    {nome: "ametista", valor: 20, quantidade: 0}  
];

//dinheiro
global.moeda = 0;

//picareta
global.picareta = 
{
    dano: 1,
    cooldown: 15
};

//upgrades
global.upgrades = 
{
    //classe 1 - dano de picareta
    dano_picareta:
    {
        descricao: "Aumenta o dano da picareta em 0.1",
        custo: 10
    },
    //classe 2 - velocidade
    velocidade_player:
    {
        
    }
};