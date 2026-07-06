//definições dos blocos
function mina_ini_defs()
{
    //metodo rapido pra adicionar uma nova definição de bloco
    var _add_def = function(_id, _hp, _spr_drop, _qtd, _spawn, _cresc)
    {
        //atributos dos blocos
        bloco_defs[_id] =
        {
            hp: _hp, 
            sprite_drop: _spr_drop, 
            quantidade_drop: _qtd, 
            chance_spawn: _spawn,   //tem a ver com chance de geração
            crescimento: _cresc,    //taxa de crescimento dentro do bioma
        }
    }
    
    //adicionando as definições dos blocos
    _add_def(BLOCOS.borda,      0,  -1, 0, 0,   0);
    _add_def(BLOCOS.pedra,      10,  0, 1, 100, 0);
    _add_def(BLOCOS.roxo,       20,  1, 1, 10,  1);
    _add_def(BLOCOS.verde,      40,  2, 1, 5,   2);
    _add_def(BLOCOS.azul,       50,  3, 1, 0,   5);
    _add_def(BLOCOS.amarelo,    100, 4, 1, 0,   10);
}

//infos do bloco na mina
function mina_novo_bloco(_tipo)
{
    return
    {
        index : _tipo,
        hp : bloco_defs[_tipo].hp,
        tempo_dano : 0,
        machucado: false
    }
}

function mina_bloco_vazio()
{
    return
    {
        index : BLOCOS.vazio,
        hp : 0,
        tempo_dano : 0,
        machucado: false
    }
}