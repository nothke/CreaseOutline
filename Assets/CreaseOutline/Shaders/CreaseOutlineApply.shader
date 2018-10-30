// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Hidden/CreaseOutlineApply"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_MultTex("MultTex", 2D) = "white" {}
		_OutlineColor("Outline Color", 2D) = "white" {}
	}
	SubShader
	{
		// No culling or depth
		Cull Off ZWrite Off ZTest Always

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
			
			sampler2D _MainTex;
			sampler2D _MultTex;

			half3 _OutlineColor;

			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col = tex2D(_MainTex, i.uv);
				//col = saturate(col - 0.5);
				fixed4 col2 = tex2D(_MultTex, i.uv);
				// just invert the colors

				float crease = col2.r;
				crease = 1 - crease;

				//col.g += crease;
				//col.b *= 1 - crease;

				col.rgb = lerp(col.rgb, _OutlineColor, crease);

				return col;
			}
			ENDCG
		}
	}
}
