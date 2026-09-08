function cria_upgrade(_nome, _desc, _sprite, _custo, _level_max, _aumento_custo, _valor, _incremento, _efeito, _sufixo = "") constructor
{
    nome            = _nome;
    descricao       = _desc;
    sprite          = _sprite;
    custo_base      = _custo;
    level_max       = _level_max;
    level_atual     = 0;
    aumento_custo   = _aumento_custo;   //porcentagem
    valor_base      = _valor;           //valor que vai aumentar no efeito
    incremento      = _incremento;      //incremento do prox valor
    efeito          = method(self,_efeito);
    sufixo          = _sufixo;
    
    //calcula o custo do prox nivel
    static get_custo = function()
    {
        return custo_base * power(aumento_custo, level_atual);
    }
    
    //calcula o prox valor do efeito
    static get_valor = function(_level = level_atual)
    {
        return valor_base + (_level * incremento);
    }
}

global.upgrades =
{
    stamina_max: new cria_upgrade("Estamina", //nome
    "Aumenta sua capacidade de estamina.", //descrição
    0, 15, 2, 1.5, global.stamina_max, 50, //sprite, custo, level max, aumento do custo, valor, incremento
    function()
    {   
        global.stamina_max = get_valor(level_atual);
    }),
    
    capacidade_max: new cria_upgrade("Capacidade", //nome
    "Aumenta a capacidade da sua mochila na mina.", //descrição
    1, 50, 5, 1.5, global.sacola.max_peso, 20, //sprite, custo, level max, aumento do custo, valor, incremento
    function()
    {
        global.sacola.max_peso = get_valor(level_atual);
    }, "kg"),
    
    alcance_lanterna: new cria_upgrade("Alcance da Lanterna", //nome
    "Aumenta o alcance da lanterna.", //descrição
    2, 30, 3, 1.5, global.alcance_lanterna, .1, //sprite, custo, level max, aumento do custo, valor, incremento
    function()
    {
        global.alcance_lanterna = get_valor(level_atual);
    }),
    
    chance_critico: new cria_upgrade("Chance de Crítico", //nome
    "Ao minerar, tem chance de um golpe crítico que causa o dobro de dano.", //descrição
    3, 40, 5, 1.5, global.chance_critico, 5, //sprite, custo, level max, aumento do custo, valor, incremento
    function()
    {
        global.chance_critico = get_valor(level_atual);
    }, "%"),
    
    chance_drop: new cria_upgrade("Chance do Drop", //nome
    "Chance do bloco deixar 2 drops em vez de 1.", //descrição
    4, 30, 5, 1.5, global.chance_drop, 5, //sprite, custo, level max, aumento do custo, valor, incremento
    function()
    {
        global.chance_drop = get_valor(level_atual);
    }, "%"),
    
    velocidade_player: new cria_upgrade("Velocidade Anfíbia", //nome
    "Aumenta sua velocidade de movimentação.", //descrição
    5, 30, 5, 1.5, 100, 10, //sprite, custo, level max, aumento do custo, valor, incremento
    function()
    {
        var _mult = get_valor(level_atual) / 100;
        global.speed = 2 * _mult;
    }, "%"),
    
    drop_atracao: new cria_upgrade("Imã de Coleta", //nome
    "Aumenta o alcance de coleta dos minérios.", //descrição
    6, 30, 5, 1.5, global.drop_atracao, 5, //sprite, custo, level max, aumento do custo, valor, incremento
    function()
    {
        global.drop_atracao = get_valor(level_atual);
    }),
    
    mais_minerio: new cria_upgrade("Mais Minérios", //nome
    "Aparece mais minérios do que pedras.", //descrição
    7, 30, 5, 1.5, global.mais_minerio, 10, //sprite, custo, level max, aumento do custo, valor, incremento
    function()
    {
        global.mais_minerio = get_valor(level_atual);
    }, "%"),
    
    minerio_antes: new cria_upgrade("Minérios Raros!", //nome
    "Minérios raros começam a aparecer antes.", //descrição
    8, 30, 5, 1.5, global.minerio_antes, 10, //sprite, custo, level max, aumento do custo, valor, incremento
    function()
    {
        global.minerio_antes = get_valor(level_atual);
    }, "%"),
    
    aumenta_valor_minerio: new cria_upgrade("Aumenta Valor do Minério", //nome
    "Aumenta o valor de venda dos minérios.", //descrição
    9, 30, 5, 1.5, global.minerio_antes, 10, //sprite, custo, level max, aumento do custo, valor, incremento
    function()
    {
        global.minerio_antes = get_valor(level_atual);
    }, "%"),
}