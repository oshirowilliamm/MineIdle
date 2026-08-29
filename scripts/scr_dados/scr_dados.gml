//moeda
global.moeda = 50;

//inventario da sacola
global.sacola = 
{
    max_peso: 20,
    peso_atual: 0,
    
    itens: {},
};

//inventario global (da vila)
global.inventario_global =
{
    minerios: {},
    limpos: {},
    refinados: {},
}

//stamina
global.stamina_max = 50;
global.stamina_atual = global.stamina_max;

//lanterna do player
global.alcance_lanterna = .7;
global.brilho_lanterna = 1;

//picareta
global.picareta = 
{
    dano: 5,
    cooldown: 15
};