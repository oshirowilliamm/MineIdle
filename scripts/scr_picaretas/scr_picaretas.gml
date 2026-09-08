//tipos de picaretas
global.tipos_picareta =
[
    {nome: "Picareta Inicial", dano: 5, cooldown: 15},
    {nome: "Picareta de Ametilita", dano: 8, cooldown: 12},
    {nome: "Picareta de Malacuru", dano: 15, cooldown: 8},
]

//picareta atual
global.nivel_picareta = 0;
global.picareta = global.tipos_picareta[global.nivel_picareta];