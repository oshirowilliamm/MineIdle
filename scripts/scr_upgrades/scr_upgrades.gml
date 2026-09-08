function cria_upgrade(_nome, _desc, _sprite, _custo, _level_max, _aumento_custo, _valor, _incremento, _variavel, _sufixo = "") constructor
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
    sufixo          = _sufixo;
    alvo            = _variavel         //variavel do efeito do upgrade
    
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
    
    //aplica o efeito na variavel
    static aplica_efeito = function()
    {
        var _valor = get_valor(level_atual);
        
        //se o alvo for um texto, só aplica
        if (is_string(alvo) == true)
        {
            global.dados[$ alvo] = _valor;
        }
        //se for uma função, roda a função
        else if (is_callable(alvo) == true)
        {
            alvo(_valor);
        }
    }
}

global.upgrades =
{
    stamina_max: new cria_upgrade("Estamina", //nome
    "Aumenta sua capacidade de estamina.", //descrição
    0, 15, 2, 1.5, 50, 50, "stamina_max"), //sprite, custo, level max, aumento do custo, valor base, incremento, variavel
    
    capacidade_max: new cria_upgrade("Capacidade", //nome
    "Aumenta a capacidade da sua mochila na mina.", //descrição
    1, 50, 5, 1.5, 20, 20, //sprite, custo, level max, aumento do custo, valor base, incremento
    function(_val)
    {
        global.sacola.max_peso = _val;
    }, "kg"), //variavel, sufixo
    
    alcance_lanterna: new cria_upgrade("Alcance da Lanterna", //nome
    "Aumenta o alcance da lanterna.", //descrição
    2, 30, 3, 1.5, .3, .1, "alcance_lanterna"), //sprite, custo, level max, aumento do custo, valor base, incremento, variavel
    
    chance_critico: new cria_upgrade("Chance de Crítico", //nome
    "Ao minerar, tem chance de um golpe crítico que causa o dobro de dano.", //descrição
    3, 40, 5, 1.5, 0, 5, "chance_critico", "%"), //sprite, custo, level max, aumento do custo, valor base, incremento, variavel, sufixo
    
    chance_drop: new cria_upgrade("Chance do Drop", //nome
    "Chance do bloco deixar 2 drops em vez de 1.", //descrição
    4, 30, 5, 1.5, 0, 5, "chance_drop", "%"), //sprite, custo, level max, aumento do custo, valor base, incremento, variavel, sufixo
    
    velocidade_player: new cria_upgrade("Velocidade Anfíbia", //nome
    "Aumenta sua velocidade de movimentação.", //descrição
    5, 30, 5, 1.5, 100, 10, //sprite, custo, level max, aumento do custo, valor base, incremento
    function(_val)
    {
        var _mult = _val / 100;
        global.dados.speed_player = 2 * _mult;
    }, "%"), //variavel, sufixo
    
    drop_atracao: new cria_upgrade("Imã de Coleta", //nome
    "Aumenta o alcance de coleta dos minérios.", //descrição
    6, 30, 5, 1.5, 25, 5, "drop_atracao"), //sprite, custo, level max, aumento do custo, valor base, incremento, variavel
    
    mais_minerio: new cria_upgrade("Mais Minérios", //nome
    "Aparece mais minérios do que pedras.", //descrição
    7, 30, 5, 1.5, 0, 10, "mais_minerio", "%"), //sprite, custo, level max, aumento do custo, valor base, incremento, variavel, sufixo
    
    minerio_antes: new cria_upgrade("Minérios Raros!", //nome
    "Minérios raros começam a aparecer antes.", //descrição
    8, 30, 5, 1.5, 0, 10, "minerio_antes", "%"), //sprite, custo, level max, aumento do custo, valor base, incremento, variavel, sufixo
    
    aumenta_valor_minerio: new cria_upgrade("Aumenta Valor do Minério", //nome
    "Aumenta o valor de venda dos minérios.", //descrição
    9, 30, 5, 1.5, 0, 50, "mult_venda_bruto", "%"), //sprite, custo, level max, aumento do custo, valor base, incremento, variavel, sufixo
    
    aumenta_valor_puro: new cria_upgrade("Aumenta Valor do Minério Puro", //nome
    "Aumenta o valor de venda dos minérios puros.", //descrição
    10, 30, 5, 1.5, 0, 50, "mult_venda_puro", "%"), //sprite, custo, level max, aumento do custo, valor base, incremento, variavel, sufixo
    
    aumenta_valor_refinado: new cria_upgrade("Aumenta Valor do Minério Refinado", //nome
    "Aumenta o valor de venda dos minérios refinados.", //descrição
    11, 30, 5, 1.5, 0, 50, "mult_venda_refinado", "%"), //sprite, custo, level max, aumento do custo, valor base, incremento, variavel, sufixo
}