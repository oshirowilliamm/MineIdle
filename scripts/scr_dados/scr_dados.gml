//itens
global.inventario = 
{
    minerio:
    [   
        {nome: "Pedra",     valor: 1,  quantidade: 0, peso: 200,  descoberto: false},
        {nome: "Roxo",      valor: 2,  quantidade: 0, peso: 400,  descoberto: false},
        {nome: "Laranja",   valor: 5,  quantidade: 0, peso: 600,  descoberto: false},
        {nome: "Verde",     valor: 5,  quantidade: 0, peso: 800,  descoberto: false},
        {nome: "Rosa",      valor: 20, quantidade: 0, peso: 1000, descoberto: false}
    ],
    refinado:
    [
        {nome: "Rocha Roxo",      valor: 2,  quantidade: 0, peso: 400,  descoberto: false},
        {nome: "Rocha Laranja",   valor: 5,  quantidade: 0, peso: 600,  descoberto: false},
        {nome: "Cristal Verde",   valor: 5,  quantidade: 0, peso: 800,  descoberto: false},
        {nome: "Cristal Rosa",    valor: 20, quantidade: 0, peso: 1000, descoberto: false}
    ]
};

//itens da sacola
global.inventario_sacola = 
{
    minerio: [0, 0, 0, 0, 0],
    refinado: [0, 0, 0, 0]
};

//biomas
global.biomas =
[
    {
        nome: "Caverna",
        conteudo:
        [
            {index: BLOCOS.pedra,   chance: 100, cresc: 0},
            {index: BLOCOS.roxo,    chance: 5,   cresc: .5},
            {index: BLOCOS.laranja,   chance: 1,   cresc: .5},
            {index: BLOCOS.verde,    chance: 0,   cresc: .3},
            {index: BLOCOS.rosa, chance: 0,   cresc: .2}
        ]
    },
    { 
        nome: "Deserto", 
        conteudo: [
            {index: BLOCOS.pedra,   chance: 80, cresc: 0},
            {index: BLOCOS.laranja,    chance: 10, cresc: 2},
            {index: BLOCOS.rosa, chance: 5,  cresc: 3}
        ] 
    }
]

//picareta
global.picareta = 
{
    dano: 5,
    cooldown: 15
};



