//tipos de picaretas
global.tipos_picareta =
[
    {nome: "Picareta Inicial", dano: 5, cooldown: 20},
    {nome: "Picareta de Ametilita", dano: 15, cooldown: 16},
    {nome: "Picareta de Malacuru", dano: 35, cooldown: 12},
]

//picareta atual
global.nivel_picareta = 0;
global.picareta = global.tipos_picareta[global.nivel_picareta];