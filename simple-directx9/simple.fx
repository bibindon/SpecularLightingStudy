float4x4 g_matWorldViewProj;
float4 g_lightNormal = { 0.259f, 0.864f, 0.432f, 0.0f };
float4 g_cameraPos = { 10.f, 10.f, 10.f, 0.0f };

texture texture1;
sampler textureSampler = sampler_state {
    Texture = (texture1);
    MipFilter = LINEAR;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
};

void VertexShader1(in  float4 inPosition  : POSITION,
                   in  float4 inNormal    : NORMAL0,
                   in  float4 inTexCood   : TEXCOORD0,

                   out float4 outPosition : POSITION,
                   out float4 outDiffuse  : COLOR0,
                   out float4 outTexCood  : TEXCOORD0)
{
    outPosition = mul(inPosition, g_matWorldViewProj);

    // ÉXÉyÉLÉÖÉâåıÇÃã≠Ç≥ÇãÅÇﬂÇÈ
    float4 cameraDir = g_cameraPos - inPosition;
    float4 cameraNorm = normalize(cameraDir);
    float4 halfVector = cameraNorm + g_lightNormal;
    halfVector = normalize(halfVector);

    float specularPower = dot(halfVector, inNormal);

    float lightIntensity = dot(inNormal, g_lightNormal);
    outDiffuse.rgb = max(0, lightIntensity);
    outDiffuse.rgb += pow(specularPower, 32.f) * 100.f;
    outDiffuse.a = 1.0f;

    outTexCood = inTexCood;
}

void PixelShader1(in float4 inScreenColor : COLOR0,
                  in float2 inTexCood     : TEXCOORD0,

                  out float4 outColor     : COLOR)
{
    float4 workColor = (float4)0;
    workColor = tex2D(textureSampler, inTexCood);
    outColor = inScreenColor * workColor;

    outColor = saturate(outColor);
}

technique Technique1
{
   pass Pass1
   {
      VertexShader = compile vs_3_0 VertexShader1();
      PixelShader = compile ps_3_0 PixelShader1();
   }
}
