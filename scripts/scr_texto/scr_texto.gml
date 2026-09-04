//texto normal
function texto_scribble(_x, _y, _texto, _xscale = .2, _yscale = _xscale, _halign = 0, _valign = 0, _cor = c_white, _alpha = 1, _font = "fnt_game")
{
    scribble(_texto)
        .starting_format(_font, c_white)
        .align(_halign, _valign)
        .scale(_xscale, _yscale)
        .blend(_cor, _alpha)
        .draw(_x, _y);
}

//texto ext
function texto_scribble_ext(_x, _y, _texto, _xscale = .2, _yscale = _xscale, _halign = 0, _valign = 0, _cor = c_white, _alpha = 1, _font = "fnt_game", _typist = undefined, _wrap = -1)
{
    var _txt = scribble(_texto)
        .starting_format(_font, c_white)
        .align(_halign, _valign)
        .scale(_xscale, _yscale)
        .blend(_cor, _alpha)
    
    //aplicando wrap
    if (_wrap > 0)
    {
        _txt.wrap(_wrap);
    }
    
    //aplicando typist
    if (_typist != undefined)
    {
        _txt.draw(_x, _y, _typist);
    }
    else
    {
        _txt.draw(_x, _y);
    }
}

//formatacao de numero
function formata_moeda(_valor)
{
    //bilhao
    if (_valor >= 1000000000)
    {
        var _num = _valor / 1000000000;
        var _str = string_format(_num, 0, 1);
        _str = string_replace(_str, ".0", "");
        
        //tirando o numero depois do . apos a dezena
        if (_num > 10)
        {
            _str = string_format(_num, 0, 0);
        }
        
        return _str + "B";
    }
    //milhao
    else if (_valor >= 1000000)
    {
        var _num = _valor / 1000000;
        var _str = string_format(_num, 0, 1);
        _str = string_replace(_str, ".0", "");
        
        //tirando o numero depois do . apos a dezena
        if (_num > 10)
        {
            _str = string_format(_num, 0, 0);
        }
        
        return _str + "M";
    }
    //mil
    else if (_valor >= 1000)
    {
        var _num = _valor / 1000;
        var _str = string_format(_num, 0, 1);
        _str = string_replace(_str, ".0", "");
        
        //tirando o numero depois do . apos a dezena
        if (_num > 10)
        {
            _str = string_format(_num, 0, 0);
        }
        
        return _str + "K";
    }
    
    //menor que mil
    return string(round(_valor));
}