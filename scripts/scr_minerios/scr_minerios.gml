function Minerio(_nome, _sprite, _cor, _valor, _peso = 1, _drop = 1) constructor 
{
    nome    = _nome;
    sprite  = _sprite;
    cor     = _cor;
    valor   = _valor;
    peso    = _peso;
    drop_qtd = _drop;
}

function MinerioBruto(_nome, _sprite, _cor, _valor, _peso, _vida, _stamina, _pedras = 0, _qtd_refina = 0)
: Minerio(_nome, _sprite, _cor, _valor, _peso) constructor
{
    vida = _vida;
    stamina = _stamina;
    
    if (_pedras > 0)
    {
        pedras = _pedras;
        qtd_refina = _qtd_refina;
    }
}

function MinerioPuro(_nome, _sprite, _cor, _valor, _peso, _pedras = 0, _qtd_refina = 0) 
: Minerio(_nome, _sprite, _cor, _valor, _peso) constructor 
{
    if (_pedras > 0) 
    {
        pedras = _pedras;
        qtd_refina = _qtd_refina;
    }
}

global.minerios = 
{
    #region Bioma 1
        
        //brutos
        //nome, index da sprite, cor, valor, peso, vida, stamina perdida, pedras e minerios pra refinação
        b1_pedra:    new MinerioBruto("Stone",     0, cor_b1_pedra,    1, 2,  10, 1),
        b1_rocha1:   new MinerioBruto("Ametilita", 1, cor_b1_rocha1,   10, 4,  20, 3,  20, 2),
        b1_rocha2:   new MinerioBruto("Malacuru",  2, cor_b1_rocha2,   30, 6,  40, 10, 40, 2),
        b1_cristal1: new MinerioBruto("Pererita",  3, cor_b1_cristal1, 40, 8,  60, 15, 60, 4),
        b1_cristal2: new MinerioBruto("Diarã",     4, cor_b1_cristal2, 50, 10, 100, 20, 80, 4),
        
        //puros
        //nome, index da sprite, cor, valor, peso, pedras e minerios pra refinação
        b1_rocha1_puro:   new MinerioPuro("Pure Ametilita", 0, cor_b1_rocha1,   100, 4,  20, 2),
        b1_rocha2_puro:   new MinerioPuro("Pure Malacuru",  1, cor_b1_rocha2,   150, 6,  20, 2),
        b1_cristal1_puro: new MinerioPuro("Pure Pererita",  2, cor_b1_cristal1, 200, 8,  20, 2),
        b1_cristal2_puro: new MinerioPuro("Pure Diarã",     3, cor_b1_cristal2, 250, 10, 20, 2),
        
        //refinados
        //nome, index da sprite, cor, valor, peso
        b1_rocha1_refinado:   new Minerio("Ametilita Bar",  0, cor_b1_rocha1,   200, 4),
        b1_rocha2_refinado:   new Minerio("Malacuru Bar",   1, cor_b1_rocha2,   300, 6),
        b1_cristal1_refinado: new Minerio("Pererita Jewel", 2, cor_b1_cristal1, 400, 8),
        b1_cristal2_refinado: new Minerio("Diarã Jewel",    3, cor_b1_cristal2, 500, 10),
        
     #endregion
}