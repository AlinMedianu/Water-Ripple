Shader "Custom/Water"
{
    Properties
    {
        _Colour ("Colour", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpTex("Normal map", 2D) = "bump" {}
		_Tess ("Tessellation", Range(1,32)) = 4
    }
    SubShader
    {
        Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }
        LOD 200

		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

        CGPROGRAM

        #pragma surface surf Standard vertex:vertex tessellate:tessellate
        #pragma target 4.6

		#include "Tessellation.cginc"

		fixed _Tess;
		fixed rippleHeight;
		fixed rippleLength;
		fixed2 ripplePosition;
        fixed4 _Colour;
        sampler2D _MainTex;
        sampler2D _BumpTex;

		struct appdata
		{
			fixed4 vertex : POSITION;
			fixed4 tangent : TANGENT;
			fixed3 normal : NORMAL;
			fixed2 texcoord : TEXCOORD0;
		};

        struct Input
        {
            fixed2 uv_MainTex;
            fixed2 uv_BumpTex;
        };

		half gradientCircle(half x)
		{
			return -pow(x - 0.1, 2) * (x - 200) * (x + 1.5);
		}

		float4 tessellate(appdata v0, appdata v1, appdata v2)
		{
			return UnityDistanceBasedTess(v0.vertex, v1.vertex, v2.vertex, 10, 25, _Tess);
		}

		void vertex(inout appdata v)
		{
			fixed circleLength = 10 - rippleLength;
			fixed circlePosition = pow(v.texcoord.x - ripplePosition.x, 2) + pow(v.texcoord.y - ripplePosition.y, 2);
			fixed rippleMap = lerp(1, 0, saturate(gradientCircle(circleLength * circlePosition)));
			v.vertex.xyz += v.normal * rippleMap * rippleHeight;
		}

        void surf (Input input, inout SurfaceOutputStandard output)
        {
            // Albedo comes from a texture tinted by color
            fixed4 pixelColour = tex2D (_MainTex, input.uv_MainTex) * _Colour;
            output.Albedo = pixelColour.rgb;
			output.Normal = tex2D(_BumpTex, input.uv_BumpTex);
            output.Alpha = pixelColour.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
