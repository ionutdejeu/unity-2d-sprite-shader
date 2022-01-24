Shader "Unlit/SunAtmosphericScatteringShader"
{
    /*
    Inspiration from https://www.shadertoy.com/view/MsVSWt
    */
    Properties
    {
        _SunPos("SunPos",Vector) = (0.5,0.5,1,1)
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float4 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 position: TEXCOORD1;

            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed3 _SunPos;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                o.position = v.vertex;
                return o;
            }

            fixed3 getSky(fixed2 uv)
            {
                float atmosphere = sqrt(1.0 - uv.y);
                fixed3 skyColor = fixed3(0.2, 0.4, 0.8);

                float scatter = pow(_SunPos.y, 1.0 / 15.0);
                scatter = 1.0 - clamp(scatter, 0.8, 1.0);

                 
                fixed3 scatterColor = fixed3(1.0, 1.0, 1.0) * (1 - scatter) + fixed3(1.0, 0.3, 0.0) * 1.5 * scatter;
                float athmosphere_ration = atmosphere / 1.3;
                return skyColor * (1 - athmosphere_ration) + scatterColor * athmosphere_ration;

            }

            fixed3 getSun(fixed2 pos,fixed2 uv) {

                float sun = 1 - distance(pos, uv.xy);
                sun = clamp(sun, 0.0, 1.0);

                float glow = sun;
                glow = clamp(glow, 0.1, 1.0);
                
                glow = pow(sun, 100.0);
                sun *= 100.0;
                sun = clamp(sun, 0.0, 1.0);
                
                glow = pow(glow, 6.0) * 1.0;
                glow = pow(glow, (uv.y));
                glow = clamp(glow, 0.0, 1.0);
                
                sun *= pow(dot(uv.y, uv.y), 1.0 / 1.65);
                glow *= pow(dot(uv.y, uv.y), 1.0 / 2.0);
                
                sun += glow;

                fixed3 sunColor = fixed3(1.0, 0.6, 0.05) * sun;

                return sunColor;

            }

            float DrawCircle(float2 uv, float radius, float fallOff)
            {
                float d = length(uv);
                return smoothstep(radius, fallOff, d);
            }


            fixed4 frag(v2f i) : SV_Target
            {

                //fixed3 col = getSky(i.uv)+getSun(_SunPos,screenPos);
                //return fixed4(col,1.0);
                //fixed2 adjuste_uv = i.uv;
                //float sun = (1 - step(0.25,distance(adjuste_uv,_SunPos)));
                //sun = clamp(sun, 0.0, 1.0);
                //float glow = sun;
                //glow = clamp(glow, 0.1, 1.0);
                //
                //glow = pow(sun, 100.0);
                //sun *= 100.0;
                //sun = clamp(sun, 0.0, 0.3);
                //
                //glow = pow(glow, 6.0) * 1.0;
                //glow = pow(glow, (adjuste_uv.y));
                //glow = clamp(glow, 0.0, 1.0);

                //sun *= pow(dot(i.uv.y, i.uv.y), 1.0 / 1.65);
                //glow *= pow(dot(i.uv.y, i.uv.y), 1.0 / 2.0);

                //sun += glow;
                fixed4 col = (0,0,0,1);
                i.uv -= .5;
                float dx = ddx(i.uv.x);
                float dy = ddy(i.uv.y);
                float aspect = dy / dx;
                i.uv.x *= aspect;

                float c = DrawCircle(i.uv, .5, .55);
                col = lerp(col, fixed4(1, 0, 0, 1), c);
                return col;
            }
            ENDCG
        }
    }
}
