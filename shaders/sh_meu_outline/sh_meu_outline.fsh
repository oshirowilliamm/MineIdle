precision highp float;

const float PI = 3.14159265359;

varying vec2 v_vTexcoord;
varying vec4 v_vColor;

uniform vec2 u_vTexel;
uniform vec2 u_vShadowDelta;

const int u_iOutlineSamples = 8;
const int u_iOutlineSize    = 2;

float InsideTexture(vec2 point)
{
    vec2 result = step(0.0, point) - step(1.0, point);
    return result.x*result.y;   
}

float SampleAlpha(vec2 inTexcoord)
{
    float alpha = 0.0;
    
    //olhando todos os pixels num quadrado 5x5 em volta
    for (int ix = -2; ix <= 2; ix++)
    {
        for (int iy = -2; iy <= 2; iy++)
        {
            if (abs(float(ix)) == 2.0 && abs(float(iy)) == 2.0) continue;
            
            vec2 texcoord = inTexcoord + u_vTexel * vec2(float(ix), float(iy));
            alpha = max(alpha, texture2D(gm_BaseTexture, texcoord).a * InsideTexture(texcoord));
        }
    }
    
    return alpha;
}

void main()
{
    if (all(equal(u_vShadowDelta, vec2(0.0))))
    {
        gl_FragColor = vec4(texture2D(gm_BaseTexture, v_vTexcoord).a,
                            SampleAlpha(v_vTexcoord),
                            0.0,
                            1.0);
    }
    else
    {
        gl_FragColor = vec4(texture2D(gm_BaseTexture, v_vTexcoord).a,
                            SampleAlpha(v_vTexcoord),
                            SampleAlpha(v_vTexcoord - u_vTexel*u_vShadowDelta),
                            1.0);
    }
}