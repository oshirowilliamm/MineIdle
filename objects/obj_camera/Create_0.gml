cam = view_camera[0];

//medidas
largura = camera_get_view_width(cam);
altura  = camera_get_view_height(cam);

//zoom
zoom_atual      = 1;
zoom_destino    = 1;
zoom_min        = .8;
zoom_max        = 2.5;
zoom_speed      = .1;

//arrastar
mouse_x_prev = 0;
mouse_y_prev = 0;

//setando a camera no centro por padrão
var _x = (room_width / 2) - (camera_get_view_width(cam) / 2);
var _y = (room_height / 2) - (camera_get_view_height(cam) / 2);
camera_set_view_pos(cam, _x, _y);