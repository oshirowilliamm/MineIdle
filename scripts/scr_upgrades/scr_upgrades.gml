global.upgrades = {};

//dano da picareta
global.upgrades.dano_picareta =
{
    nome: "Dano da Picareta",
    descricao: "Aumenta o dano da picareta em 10%", 
    level: 1,
    level_max: 5,
    custo_inicial: 20,
    custo_aumento: 1.5, //50%
    efeito: function(_lvl)
    {
        var _valor_base = global.picareta.dano;
        
        //aumenta por nivel
        global.picareta.dano += _valor_base + (_valor_base * _lvl * .1);
    },
    //posição
    coluna: 0,
    linha: 0,
    index: 0
}

//capacidade de stamina
global.upgrades.stamina =
{
    nome: "Stamina",
    descricao: "Aumenta a stamina em 10%", 
    level: 1,
    level_max: 5,
    custo_inicial: 10,
    custo_aumento: 1.5, //50%
    efeito: function(_lvl)
    {
        var _valor_base = global.stamina_max;
        
        //aumenta por nivel
        global.stamina_max += _valor_base + (_valor_base * _lvl * .1);
    },
    //posição
    coluna: 1,
    linha: 0,
    index: 1
}

//capacidade da sacola
global.upgrades.capacidade =
{
    nome: "Capacidade",
    descricao: "Aumenta a capacidade da bolsa de minérios em 10%", 
    level: 1,
    level_max: 5,
    custo_inicial: 30,
    custo_aumento: 1.5, //50%
    efeito: function(_lvl)
    {
        var _valor_base = global.peso_max;
        
        //aumenta por nivel
        global.peso_max += _valor_base + (_valor_base * _lvl * .1);
    },
    //posição
    coluna: 0,
    linha: 1,
    index: 2
}

//alcance da lanterna
global.upgrades.lanterna = 
{
    nome: "Alcance da Lanterna",
    descricao: "Aumenta o alcance da lanterna em 10%", 
    level: 1,
    level_max: 5,
    custo_inicial: 20,
    custo_aumento: 1.5, //50%
    efeito: function(_lvl)
    {
        var _valor_base = global.alcance_lanterna;
        
        //aumenta por nivel
        global.alcance_lanterna += _valor_base + (_valor_base * _lvl * .1);
    },
    //posição
    coluna: 1,
    linha: 1,
    index: 3
}
