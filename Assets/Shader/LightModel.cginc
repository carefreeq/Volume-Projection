struct a2v
{
	float4 vertex : POSITION;
	float2 uv : TEXCOORD0;
	float3 normal:NORMAL;
};
#include "AutoLight.cginc"
struct v2f
{
	float2 uv : TEXCOORD0;
	float4 pos : SV_POSITION;
	float4 wPos:TEXCOORD1;
	float3 normal:TEXCOORD2;
	LIGHTING_COORDS(3, 4)
		UNITY_FOG_COORDS(5)
};

uniform float4 _LightColor0;
uniform fixed4 _Color;
uniform sampler2D _MainTex;
uniform float4 _MainTex_ST;
#if defined(projection_bump)
uniform sampler2D _BumpTex;
#endif
#if defined(projection_illm)
uniform fixed4 _Illum;
#endif

v2f vert(a2v v)
{
	v2f o;
	o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
	o.wPos = mul(unity_ObjectToWorld, v.vertex);
	_MainTex_ST.zw *= _Time.x;
	o.uv = TRANSFORM_TEX(v.uv, _MainTex);
	o.normal = UnityObjectToWorldNormal(v.normal);
	UNITY_TRANSFER_FOG(o, o.pos);
	TRANSFER_VERTEX_TO_FRAGMENT(o)
		return o;
}

float3 lightDir;
float3 normal;

fixed4 lambert(v2f i)
{
#if defined(projection_bump)
	half3 nor = UnpackNormal(tex2D(_BumpTex, i.uv));
	normal = normalize(i.normal + nor.xyy * half3(1.2, 0, 1.2));
#else
	normal = i.normal;
#endif
	lightDir = normalize(UnityWorldSpaceLightDir(i.wPos));
	float NdotL = max(-0.3, dot(normal, lightDir));
	float atten = LIGHT_ATTENUATION(i)  * NdotL * 1.1;
	fixed4 col = tex2D(_MainTex, i.uv) * _Color;
	col.rgb *= atten * _LightColor0.rgb + UNITY_LIGHTMODEL_AMBIENT.rgb;
	return col;
}

fixed4 frag(v2f i) : SV_Target
{
	fixed4 col = lambert(i);
#if defined(projection_illm)
	float NdotL = max(0, -dot(normal, lightDir));
	col.rgb += _Illum.rgb * clamp(NdotL, 0, col.a) * _Illum.a;
#endif
	UNITY_APPLY_FOG(i.fogCoord, col);
	return col;
}