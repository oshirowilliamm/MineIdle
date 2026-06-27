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
    //classe 1 - dano
    dano:
    [
        //0
        {
            descricao: "Aumenta o dano \nda picareta \nem 0.1", 
            custo: 20,
            efeito: function()
            {
                global.picareta.dano += .1;
            }
        }
    ],
    //classe 2 - stamina
    stamina:
    [
        {
            descricao: "Aumenta a \nstamina em 0.5", 
            custo: 10,
            efeito: function()
            {
                show_message("ok");
            }
        }
    ]
};
