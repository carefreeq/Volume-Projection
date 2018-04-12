Shader "QQ/VP/LightRay"
{
	Properties
	{
		_ProjectionPower("ProjectionPower",Range(0,1)) = .5
		_ProjectionLength("ProjectionLength",Range(0,100)) = 10
		_ProjectionFadeout("Fadeout distance",float) = 5
	}
		SubShader
	{
		Tags{ "RenderType" = "Transparent"
		"Queue" = "Transparent" }
		LOD 100
		CGINCLUDE
		#pragma vertex vert
		#pragma fragment lfrag
		#pragma multi_compile_fog
		#include "UnityCG.cginc"  
		#include "Porjection.cginc"
		uniform float4 _LightColor0;
		uniform float _ProjectionPower;

		fixed4 lfrag(v2f i) : SV_Target
		{
			fixed4 col = _LightColor0;
			float NdotL = dot(i.normal, normalize(UnityWorldSpaceLightDir(i.wPos)));
			col.a = min(_ProjectionPower,(pow(1.1 - abs(NdotL), 8)));
			col.a *= pow(min(distance(_WorldSpaceCameraPos.xyz, i.wPos), _ProjectionFadeout) / _ProjectionFadeout,3);
			return col;
		}
		ENDCG
		Pass
		{
			Tags{ "LightMode" = "ForwardBase" }
			ZWrite Off
			Cull Off
			Blend SrcAlpha OneMinusSrcAlpha
			CGPROGRAM
			ENDCG
		}
		Pass
		{
		Tags{ "LightMode" = "ForwardAdd" }
		ZWrite Off
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
		CGPROGRAM
		ENDCG
		}
	}
}
