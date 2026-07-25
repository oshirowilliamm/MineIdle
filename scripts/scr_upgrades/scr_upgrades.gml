//construtor dos upgrades
function upgrade_defs(_params) constructor 
{
    //infos de parentes
    desbloqueado    = false;
    alvos           = _params.alvos;
    
    //index da sprite
    sprite          = _params.sprite; 
    
    //nomes
    nome            = _params.nome;
    descricao       = _params.descricao;
    
    //multiplicador de valor
    multiplicador   = _params.multiplicador;
    
    //level
    level           = 1;
    level_max       = _params.level_max;
    
    //pegando o seu valor (variavel global)
    valor           = _params.valor;
    prox_valor      = function() { return valor() * multiplicador; }
    
    //custo base
    custo_base      = _params.custo_base;
    custo           = function() { return round(custo_base * power(1.5, level - 1)); }
    
    //efeito
    efeito          = _params.efeito;
}

global.upgrades = {};

//stamina
global.upgrades.stamina = new upgrade_defs({
    nome:          "Stamina",
    descricao:     "Aumenta a stamina em 10%",
    custo_base:    10,
    level_max:     5,
    multiplicador: 1.1,
    alvos:         [Stamina1, Stamina2, Stamina3],
    sprite:        0,
    valor:         function() { return global.stamina_max; },
    efeito:        function() { global.stamina_max *= self.multiplicador; }
})
global.upgrades.stamina.desbloqueado = true;

//dano da picareta
global.upgrades.dano_picareta = new upgrade_defs({
    nome:          "Dano da Picareta",
    descricao:     "Aumenta o dano da picareta em 10%",
    custo_base:    20,
    level_max:     5,
    multiplicador: 1.1,
    alvos:         [],
    sprite:        1,
    valor:         function() { return global.picareta.dano; },
    efeito:        function() { global.picareta.dano *= self.multiplicador; }
})
global.upgrades.dano_picareta.desbloqueado = true;

//capacidade da sacola
global.upgrades.capacidade = new upgrade_defs({
    nome:          "Capacidade",
    descricao:     "Aumenta a capacidade da bolsa de minérios em 10%",
    custo_base:    30,
    level_max:     5,
    multiplicador: 1.1,
    alvos:         [],
    sprite:        2,
    valor:         function() { return global.peso_max; },
    efeito:        function() { global.peso_max *= self.multiplicador; },
})
global.upgrades.capacidade.desbloqueado = true;

//alcance da lanterna
global.upgrades.lanterna = new upgrade_defs({
    nome:          "Alcance da Lanterna",
    descricao:     "Aumenta o alcance da lanterna em 10%",
    custo_base:    20,
    level_max:     5,
    multiplicador: 1.1,
    alvos:         [],
    sprite:        3,
    valor:         function() { return global.alcance_lanterna; },
    efeito:        function() { global.alcance_lanterna *= self.multiplicador; }
})
global.upgrades.lanterna.desbloqueado = true;




//teste
global.upgrades.teste = new upgrade_defs({
    nome:          "Teste",
    descricao:     "Teste",
    custo_base:    0,
    level_max:     0,
    multiplicador: 0,
    alvos:         [],
    sprite:        0,
    valor:         function() { return 0 },
    efeito:        function() {}
})