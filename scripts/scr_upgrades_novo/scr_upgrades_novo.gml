function cria_upgrade(_nome, _desc, _sprite, _custo_base, _level_max, _aumento_custo, _efeito) constructor
{
    nome            = _nome;
    descricao       = _desc;
    sprite          = _sprite;
    custo_base      = _custo_base;
    level_max       = _level_max;
    level_atual     = 0;
    aumento_custo   = _aumento_custo; //porcentagem
    efeito          = _efeito;
    
    //calcula o custo do prox nivel
    static get_custo = function()
    {
        return custo_base * power(aumento_custo, level_atual);
    }
}

global.upgrades =
{
    stamina_max: new cria_upgrade("Stamina", "Aumenta a stamina em 20%", 0, 10, 1, 1.5,
    function()
    {
        global.stamina_max += global.stamina_max * .2;
    }),
    
    capacidade_max: new cria_upgrade("Capacidade", "Aumenta a capacidade em 20%", 1, 20, 3, 1.5,
    function()
    {
        global.sacola.max_peso += global.sacola.max_peso * .2;
    }),
    
    alcance_lanterna: new cria_upgrade("Alcance da Lanterna", "Aumenta o alcance da lanterna em 1", 2, 30, 2, 1.5, 
    function()
    {
        global.alcance_lanterna += .1;
    }),
}