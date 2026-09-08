//moeda
global.moeda = 0;

//stamina
global.stamina_max = 50;
global.stamina_atual = global.stamina_max;

//lanterna do player
global.alcance_lanterna = .3;

//picareta
global.tipos_picareta =
[
    {nome: "Picareta Inicial", dano: 5, cooldown: 15},
    {nome: "Picareta de Ametilita", dano: 8, cooldown: 12},
    {nome: "Picareta de Malacuru", dano: 15, cooldown: 8},
]

global.nivel_picareta = 0;
global.picareta = global.tipos_picareta[global.nivel_picareta];

//variaveis de upgrade
global.speed = 2;
global.chance_drop = 0;
global.chance_critico = 0;
global.drop_atracao = 25;
global.mais_minerio = 0;
global.minerio_antes = 0;
global.mult_venda_bruto = 0;
global.mult_venda_puro = 0;
global.mult_venda_refinado = 0;