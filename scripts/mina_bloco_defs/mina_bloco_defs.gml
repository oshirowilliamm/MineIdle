//definições dos blocos
function mina_ini_defs()
{
    //metodo rapido pra adicionar uma nova definição de bloco
    var _add_def = function(_id, _hp, _spr_drop, _qtd, _spawn)
    {
        //atributos dos blocos
        bloco_defs[_id] =
        {
            hp: _hp, 
            sprite_drop: _spr_drop, 
            quantidade_drop: _qtd, 
            chance_spawn: _spawn, //tem a ver com chance de geração
        }
        
        //adicionando o chance de spawn total
        chance_spawn_total += _spawn;
    }
    
    //adicionando as definições dos blocos
    _add_def(BLOCOS.borda,      infinity,  -1, 0, 0);
    _add_def(BLOCOS.pedra,      10,  0, 1, 50);
    _add_def(BLOCOS.roxo,       20,  1, 1, 15);
    _add_def(BLOCOS.verde,      40,  2, 1, 10);
    _add_def(BLOCOS.azul,       50,  3, 1, 5);
    _add_def(BLOCOS.amarelo,    100, 4, 1, 1);
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