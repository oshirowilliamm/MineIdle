cam = view_camera[0];

//medidas
largura = camera_get_view_width(cam);
altura  = camera_get_view_height(cam);

//zoom
zoom_niveis = [0.75, 1, 1.5, 1.75, 2, 3]; 
zoom_indice = 1;                    

zoom_atual   = zoom_niveis[zoom_indice];
zoom_destino = zoom_atual;
zoom_speed   = 0.2;

//arrastar
mouse_x_prev = 0;
mouse_y_prev = 0;
arrastando = false;

//setando a camera no centro por padrão
var _x = (room_width / 2) - (camera_get_view_width(cam) / 2);
var _y = (room_height / 2) - (camera_get_view_height(cam) / 2);
camera_set_view_pos(cam, _x, _y);