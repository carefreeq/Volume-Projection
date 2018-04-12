Shader "QQ/VP/Diffuse"
{
	Properties
	{
        _Color("Color",Color)=(0.5,0.5,0.5,1)
		_MainTex("Texture", 2D) = "white" {}
		_ProjectionColor("TrailColor",Color) = (0,0,0,.75)
		_ProjectionLength("ProjectionLength",Range(0,100)) = 10
		_ProjectionFadeout("Fadeout distance",float) = 5
	}
		SubShader
		{
			CGINCLUDE
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fog
			#include "UnityCG.cginc"  
			ENDCG
			Tags{ "RenderType" = "Transparent"
			"Queue" = "Transparent" }
			LOD 100
			Pass
			{
				Tags{ "LightMode" = "ForwardBase" }
				CGPROGRAM
				#pragma multi_compile_fwdbase_fullshadows
				#include "LightModel.cginc"
				ENDCG
			}
			Pass
			{
				Tags{ "LightMode" = "ForwardBase" }
				ZWrite Off
				Cull Off
				Blend SrcAlpha OneMinusSrcAlpha
				CGPROGRAM
				#include "Porjection.cginc"
				ENDCG
			}

			Pass
			{
				Blend One One
				Tags{ "LightMode" = "ForwardAdd" }
				CGPROGRAM
				#pragma multi_compile_fwdadd_fullshadows
				#include "LightModel.cginc"
				ENDCG
			}
			Pass
			{
				Tags{ "LightMode" = "ForwardAdd" }
				ZWrite Off
				Cull Off
				Blend SrcAlpha OneMinusSrcAlpha
				CGPROGRAM
				#include "Porjection.cginc"
				ENDCG
			}
		}
			FallBack "Diffuse"
}
