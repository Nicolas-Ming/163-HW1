Shader "HW/Phong"
{
    Properties
    {   
        _Color ("Color", Color) = (1, 1, 1, 1) 
        _Shininess ("Shininess", Float) = 10 
        _SpecColor ("Specular Color", Color) = (1, 1, 1, 1) 
		_Speed("Speed", Float) = 1.0
		_Twistiness("Twistiness", Float) = 1.0
    }
    
    SubShader
    {
        Pass {
            Tags { "LightMode" = "ForwardAdd" }
            // Blend One One //Turn on additive blending if you have more than one point light
          
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
           
            uniform float4 _LightColor0; 
            uniform float4 _Color; 
            uniform float4 _SpecColor;
            uniform float _Shininess;          
			uniform float _Speed;
			uniform float _Twistiness;
          
            struct appdata
            {
                    float4 vertex : POSITION;
                    float3 normal : NORMAL;
            };

            struct v2f
            {
                    float4 vertex : SV_POSITION;
                    float3 normal : NORMAL;       
                    float3 vertexInWorldCoords : TEXCOORD1;
            };

 
           v2f vert(appdata v)
           { 
                v2f o;

				const float PI = 3.14159;

				float rad = sin(_Time.y * _Speed);

				float useTwist = 10.0;

				if (_Twistiness >= 10.0) {
					useTwist = 0.01;
				}
				else if (_Twistiness <= 0.0) {
					useTwist = 10;
				}
				else {
					useTwist = 10 - _Twistiness;
				}

				float ct = cos(v.vertex.y / useTwist);
				float st = sin(v.vertex.y / useTwist);

				float newx = v.vertex.x + (v.vertex.x * ct * rad - v.vertex.z * st * rad);
				float newz = v.vertex.z + (v.vertex.x * st * rad + v.vertex.z * ct * rad);
				float newy = v.vertex.y;

				float4 xyz = float4(newx, newy, newz, 1.0);

                o.vertexInWorldCoords = mul(unity_ObjectToWorld, xyz); 
                o.normal = v.normal; 
                o.vertex = UnityObjectToClipPos(xyz); 
                
              

                return o;
           }

           fixed4 frag(v2f i) : SV_Target
           {
                
                float3 P = i.vertexInWorldCoords.xyz;
                float3 N = normalize(i.normal);
                float3 V = normalize(_WorldSpaceCameraPos - P);
                float3 L = normalize(_WorldSpaceLightPos0.xyz - P);
                float3 H = normalize(L + V);
                
                float3 Kd = _Color.rgb;
                float3 Ka = UNITY_LIGHTMODEL_AMBIENT.rgb;
                float3 Ks = _SpecColor.rgb;
                float3 Kl = _LightColor0.rgb; 
                
                
               
                float3 ambient = Ka;
                
             
                float diffuseVal = max(dot(N, L), 0);
                float3 diffuse = Kd * Kl * diffuseVal;
                
                
                float specularVal = pow(max(dot(N,H), 0), _Shininess);
                
                if (diffuseVal <= 0) {
                    specularVal = 0;
                }
                
                float3 specular = Ks * Kl * specularVal;
                
                return float4(ambient + diffuse + specular, 1.0);

            }
            
            ENDCG
 
            
        }
            
    }
}
