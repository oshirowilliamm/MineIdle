global.upgrades = {};

//stamina
global.upgrades.stamina =
{
    //infos de parentes
    desbloqueado: true,
    alvos: [Stamina1, Stamina2, Stamina3],
    sprite: 0,
    
    //nomes
    nome: "Stamina",
    descricao: "Aumenta a stamina em 10%",
    valor: global.stamina_max,
    
    //level
    level: 1,
    level_max: 5,
    
    //custo
    custo: 10,
}

//teste
global.upgrades.picareta =
{
    //infos de parentes
    desbloqueado: true,
    alvos: [],
    sprite: 1,
    
    //nomes
    nome: "Picareta",
    descricao: "Aumenta o dano da picareta em 10%",
    valor: global.picareta.dano,
    
    //level
    level: 1,
    level_max: 5,
    
    //custo
    custo: 15,
}

//teste2
global.upgrades.capacidade =
{
    //infos de parentes
    desbloqueado: false,
    alvos: [],
    sprite: 2,
    valor: global.peso_max,
    
    //nomes
    nome: "Picareta",
    descricao: "Aumenta a picareta em 10%",
    
    //level
    level: 1,
    level_max: 5,
    
    //custo
    custo: 25,
}

//capacidade de stamina
//global.upgrades.stamina =
//{
    //nome: "Stamina",
    //descricao: "Aumenta a stamina em 10%", 
    //valor: global.stamina_max,
    //
    ////level
    //level: 1,
    //level_max: 5,
    //
    ////custo
    //custo: 10,
    //custo_aumento: 1.5, //50%
    //
    ////efeito
    //efeito: function(_lvl)
    //{
        //var _valor_base = global.stamina_max;
        //
        ////aumenta por nivel
        //global.stamina_max += _valor_base + (_valor_base * _lvl * .1);
    //},
    //
    ////posição
    //coluna: 1,
    //linha: 0,
    //index: 1
//}

/*
//dano da picareta
global.upgrades.dano_picareta =
{
    //dados
    nome: "Dano da Picareta",
    descricao: "Aumenta o dano da picareta em 10%", 
    valor: global.picareta.dano,
    
    //level
    level: 1,
    level_max: 5,
    
    //custo
    custo: 20,
    custo_aumento: 1.5, //50%
    
    //efeito
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

//capacidade da sacola
global.upgrades.capacidade =
{
    nome: "Capacidade",
    descricao: "Aumenta a capacidade da bolsa de minérios em 10%", 
    valor: global.peso_max,
    
    //level
    level: 1,
    level_max: 5,
    
    //custo
    custo: 30,
    custo_aumento: 1.5, //50%
    
    //efeito
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
    valor: global.alcance_lanterna,
    
    //level
    level: 1,
    level_max: 5,
    
    //custo
    custo: 20,
    custo_aumento: 1.5, //50%
    
    //efeito
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
*/
