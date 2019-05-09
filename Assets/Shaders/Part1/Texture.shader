Shader "HW/Texture"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Speed("Speed", Float) = 1.0
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

				#include "UnityCG.cginc"

				uniform float _Speed;

            struct appdata
            {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float3 normal : NORMAL;
                float4 vertex : SV_POSITION;
				float timeVal : Float;
            };

			float3x3 getRotationMatrixX(float theta) {

				float s = -sin(theta);
				float c = cos(theta);
				return float3x3(1, 0, 0, 0, c, -s, 0, s, c);
			}

			float3x3 getRotationMatrixY(float theta) {

				float s = -sin(theta);
				float c = cos(theta);
				return float3x3(c, 0, s, 0, 1, 0, -s, 0, c);
			}

			float3x3 getRotationMatrixZ(float theta) {

				float s = -sin(theta);
				float c = cos(theta);
				return float3x3(c, -s, 0, s, c, 0, 0, 0, 1);
			}

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
				const float PI = 3.14159;

				float rad = sin(_Time.y * _Speed) * PI * 8;

				float3x3 rotationMatrix = getRotationMatrixX(rad);

				float3 rotatedVertex = mul(rotationMatrix, v.vertex.xyz);

				float4 xyz = float4(rotatedVertex, 1.0);

                o.vertex = UnityObjectToClipPos(xyz);
				o.normal = v.normal;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				return col;
            }
            ENDCG
        }
    }
}
