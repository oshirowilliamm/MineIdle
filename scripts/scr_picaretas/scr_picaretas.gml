//tipos de picaretas
global.tipos_picareta =
[
    {nome: "Picareta Inicial", dano: 5, cooldown: 30, preco: 0, comprada: true},
    {nome: "Picareta de Pedra", dano: 10, cooldown: 20, preco: 100, comprada: false},
    {nome: "Picareta de Ametilita", dano: 15, cooldown: 16, preco: 1000, comprada: false},
    {nome: "Picareta de Malacuru", dano: 35, cooldown: 12, preco: 5000, comprada: false},
    {nome: "Picareta de Pererita", dano: 50, cooldown: 10, preco: 10000, comprada: false},
    {nome: "Picareta de Diarã", dano: 80, cooldown: 9, preco: 50000, comprada: false},
]

//picareta atual
global.nivel_picareta = 0;
global.picareta = global.tipos_picareta[global.nivel_picareta];