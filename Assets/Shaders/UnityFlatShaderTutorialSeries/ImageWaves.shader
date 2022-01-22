Shader "Unlit/ImageWaves"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Duration ("Duration",float) = 6.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct v2f
            {
                float4 position: TEXCOORD1;
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float _Duration;

            v2f vert (appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                o.position = v.vertex;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                float2 pos = i.position.xy * 2.0;
                float l = length(pos);
                float2 ripple = i.uv + pos / l * 3.0 * cos(l * 12.0 - _Time.y * 4.0);
                float theta = fmod(_Time.y, _Duration) * (UNITY_TWO_PI / _Duration);
                float delta = (sin(theta) * 1.0) / 2.0;
                // sample the texture
                float uv = lerp(ripple, i.uv, delta);
                fixed3 color = tex2D(_MainTex, uv);
                return fixed4(color,1.0);
            }
            ENDCG
        }
    }
}
