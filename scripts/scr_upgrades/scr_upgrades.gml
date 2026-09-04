function cria_upgrade(_nome, _desc, _sprite, _custo, _level_max, _aumento_custo, _valor, _incremento, _efeito) constructor
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
    efeito          = _efeito;
    
    //calcula o custo do prox nivel
    static get_custo = function()
    {
        return custo_base * power(aumento_custo, level_atual);
    }
    
    //calcula o prox valor do efeito
    static get_valor = function(_level = _level_atual)
    {
        return valor_base + (_level * incremento);
    }
}

global.upgrades =
{
    stamina_max: new cria_upgrade("Stamina", //nome
    "Aumenta a stamina em [cor_upgrade_verde]50[/]", //descrição
    0, 10, 1, 1.5, global.stamina_max, 50, //valores
    function()
    {   
        global.stamina_max = get_valor(level_atual);
    }),
    
    capacidade_max: new cria_upgrade("Capacidade", //nome
    "Aumenta a capacidade em [cor_upgrade_verde]20[/]", //descrição
    1, 20, 3, 1.5, global.sacola.max_peso, 20, //valores
    function()
    {
        global.sacola.max_peso = get_valor(level_atual);
    }),
    
    alcance_lanterna: new cria_upgrade("Alcance da Lanterna", //nome
    "Aumenta o alcance da lanterna em [cor_upgrade_verde]1[/]", //descrição
    2, 30, 2, 1.5, global.alcance_lanterna, .1, //valores
    function()
    {
        global.alcance_lanterna = get_valor(level_atual);
    }),
}