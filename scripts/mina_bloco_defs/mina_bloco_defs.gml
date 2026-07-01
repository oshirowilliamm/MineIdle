//definições dos blocos
function mina_ini_defs()
{
    //metodo rapido pra adicionar uma nova definição de bloco
    var _add_def = function(_id, _nome, _hp, _spr_drop, _qtd, _spawn)
    {
        //atributos dos blocos
        bloco_defs[_id] =
        {
            nome:   _nome, 
            hp: _hp, 
            sprite_drop: _spr_drop, 
            quantidade_drop: _qtd, 
            chance_spawn: _spawn, //tem a ver com chance de geração
        }
        
        //adicionando o chance de spawn total
        chance_spawn_total += _spawn;
    }
    
    //adicionando as definições dos blocos
    _add_def(BLOCOS.borda,    "Parede",   infinity, -1, 0, 0);
    _add_def(BLOCOS.pedra,    "Pedra",    10,  0, 1, 50);
    _add_def(BLOCOS.roxo,     "Roxo",     20,  1, 1, 15);
    _add_def(BLOCOS.verde,    "Verde",    40,  2, 1, 10);
    _add_def(BLOCOS.azul,	  "Azul",	  50,  3, 1, 5);
    _add_def(BLOCOS.amarelo,  "Amarelo",  100, 4, 1, 1);
}

//infos do bloco na mina
function mina_novo_bloco(_tipo)
{
    return
    {
        index : _tipo,
        hp : bloco_defs[_tipo].hp,
        tempo_dano : 0
    }
}