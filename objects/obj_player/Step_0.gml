//ajustando profundidade do player
depth = -y;

//pegando a direção do player
var _dir = point_direction(x, y, mouse_x, mouse_y);
//transformando a dir em apenas 4 valores -> 0, 1, 2, 3
dir = round(_dir / 90) % 4;

//pegando direções da picareta para espelhar de acordo com o dir
switch (dir) 
{
    //direita
    case 0: 
        equip_dir = 1;
        //ajustando pontos de origem
        equip_x = 4;
        equip_y = 18;
        //ajustando depth
        equip_depth = depth - 5;
    break;
    //cima
    case 1: 
        equip_dir = -1;
        //ajustando pontos de origem
        equip_x = 4;
        equip_y = 18;
        //ajustando depth 
        equip_depth = depth + 5;
    break;
    //esquerda
    case 2: 
        equip_dir = -1;
        //ajustando pontos de origem
        equip_x = 4;
        equip_y = 18;
        //ajustando depth
        equip_depth = depth - 5;
    break;
    //baixo
    case 3: 
        equip_dir = 1;
        //ajustando pontos de origem
        equip_x = 3;
        equip_y = 19;
        //ajustando depth
        equip_depth = depth - 5;
    break;
}

//corrigindo y em relação ao ponto de origem
yy = y - 15;



//aplicando as funções
controles();
roda_estado();
segura_picareta();
stamina();


debugs();