//minerio base e refinado
function Minerio(_nome, _sprite, _cor, _valor, _peso = 1) constructor 
{
    nome    = _nome;
    sprite  = _sprite;
    cor     = _cor;
    valor   = _valor;
    peso    = _peso;
    
    static get_valor = function()
    {
        return valor * (1 + global.dados.mult_venda_refinado / 100);
    }
}

//minerio bruto
function MinerioBruto(_nome, _sprite, _cor, _valor, _peso, _vida, _stamina, _pedras = 0, _qtd_refina = 0)
: Minerio(_nome, _sprite, _cor, _valor, _peso) constructor
{
    vida = _vida;
    stamina = _stamina;
    
    static get_valor = function()
    {
        return valor * (1 + global.dados.mult_venda_bruto / 100);
    }
    
    static get_stamina = function()
    {
        var _valor = stamina - (stamina * (global.dados.minerio_menos_stamina / 100));
        return max(1, _valor);
    }
    
    if (_pedras > 0)
    {
        pedras = _pedras;
        qtd_refina = _qtd_refina;
    }
}

//bloco de pedra
function Pedra(_nome, _sprite, _cor, _valor, _peso, _vida, _stamina) 
: MinerioBruto(_nome, _sprite, _cor, _valor, _peso, _vida, _stamina) constructor
{
    static get_valor = function()
    {
        return valor;
    }
}

//minerio puro
function MinerioPuro(_nome, _sprite, _cor, _valor, _peso, _pedras = 0, _qtd_refina = 0) 
: Minerio(_nome, _sprite, _cor, _valor, _peso) constructor 
{
    static get_valor = function()
    {
        return valor * (1 + global.dados.mult_venda_puro / 100);
    }
    
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
        b1_pedra:    new Pedra("Stone", 0, cor_b1_pedra, 1, 1,  10, 2),
        b1_rocha1:   new MinerioBruto("Ametilita", 1, cor_b1_rocha1,   10, 4,  25, 3,   10, 2),
        b1_rocha2:   new MinerioBruto("Malacuru",  2, cor_b1_rocha2,   40, 6,  60, 5,   25, 2),
        b1_cristal1: new MinerioBruto("Pererita",  3, cor_b1_cristal1, 150, 8,  120, 8,  50, 3), 
        b1_cristal2: new MinerioBruto("Diarã",     4, cor_b1_cristal2, 600, 10, 300, 12, 100, 3),
        
        //puros
        //nome, index da sprite, cor, valor, peso, pedras e minerios pra refinação
        b1_rocha1_puro:   new MinerioPuro("Pure Ametilita", 0, cor_b1_rocha1,   50, 4,   15, 2),
        b1_rocha2_puro:   new MinerioPuro("Pure Malacuru",  1, cor_b1_rocha2,   200, 6,  30, 2),
        b1_cristal1_puro: new MinerioPuro("Pure Pererita",  2, cor_b1_cristal1, 800, 8,  60, 2),
        b1_cristal2_puro: new MinerioPuro("Pure Diarã",     3, cor_b1_cristal2, 3500, 10, 120, 2),
        
        //refinados
        //nome, index da sprite, cor, valor, peso
        b1_rocha1_refinado:   new Minerio("Ametilita Bar",  0, cor_b1_rocha1,   60, 4),
        b1_rocha2_refinado:   new Minerio("Malacuru Bar",   1, cor_b1_rocha2,   250, 6),
        b1_cristal1_refinado: new Minerio("Pererita Jewel", 2, cor_b1_cristal1, 1000, 8),
        b1_cristal2_refinado: new Minerio("Diarã Jewel",    3, cor_b1_cristal2, 4000, 10),
        
     #endregion
}