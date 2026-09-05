function efeito_flutuar(_yatual, _ydest, _amplitude = 5, _velocidade = 300, _suavidade = .2)
{
    var _yalvo = _ydest + sin(current_time / _velocidade) * _amplitude;
    return lerp(_yatual, _yalvo, _suavidade);
}
