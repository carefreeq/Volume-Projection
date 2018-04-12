struct a2v
{
	float4 vertex : POSITION;
	float3 normal:NORMAL;
};

struct v2f
{
	float4 vertex : SV_POSITION;
	float3 wPos:TEXCOORD1;
	float3 normal:TEXCOORD2;
};
uniform fixed4 _ProjectionColor;
uniform float _ProjectionLength;
uniform float _ProjectionFadeout;
v2f vert(a2v v)
{
	v2f o;
	o.wPos = mul(unity_ObjectToWorld, v.vertex);
	o.normal = UnityObjectToWorldNormal(v.normal);
	float3 lightDir = normalize(UnityWorldSpaceLightDir(o.wPos));
	v.vertex.xyz += v.normal*0.01;
	v.vertex = mul(UNITY_MATRIX_M, v.vertex);
	float NdotL = min(0, dot(o.normal, lightDir));
	v.vertex.xyz += lightDir *NdotL* _ProjectionLength;
	o.vertex = v.vertex = mul(UNITY_MATRIX_VP, v.vertex);
	return o;
}
fixed4 frag(v2f i) : SV_Target
{
	fixed4 col = _ProjectionColor;
	float NdotL = dot(i.normal, normalize(UnityWorldSpaceLightDir(i.wPos)));
	col.a = min(_ProjectionColor.a,(pow(1.1 - abs(NdotL), 8)));
	col.a *= pow(min(distance(_WorldSpaceCameraPos.xyz, i.wPos), _ProjectionFadeout) / _ProjectionFadeout, 3);
	return col;
}