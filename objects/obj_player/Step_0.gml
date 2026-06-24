//ajustando profundidade do player
depth = -y;

//pegando a direção do player
var _dir = point_direction(x, y, mouse_x, mouse_y);
/*
     quando a direção é dividida por 90, ela gera apenas 4 valores:
     posição = 0 -> direita
     posição = 1 -> cima
     posição = 2 -> esquerda
     posição = 3 -> baixo
     o round serve pra arredondar o angulo e o mod para n ter o numero 4
*/
dir = round(_dir / 90) mod 4;

//aplicando as funções
controles();
roda_estado();

#region Debugs

if (keyboard_check_pressed(vk_tab))
{
    debug = !debug;
}

#endregion