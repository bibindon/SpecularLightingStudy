float4x4 g_matWorldViewProj;
float4 g_lightPos = float4(-10.f, 10.f, -10.f, 0.0f);
float4 g_cameraPos = float4(10.f, 5.f, 10.f, 0.0f);
float3 g_ambient = float3(0.2f, 0.2f, 0.2f);

// �s�N�Z���E�X�y�L�����̒����p
float g_SpecPower = 64.0f; // �s���i�n�C���C�g�̍L����j
float g_SpecIntensity = 1.5f; // ����
float3 g_SpecColor = float3(1, 1, 1); // �F�i�K�v�Ȃ�ύX�j

texture texture1;
sampler textureSampler = sampler_state
{
    Texture = (texture1);
    MipFilter = LINEAR;
    MinFilter = LINEAR;
    MagFilter = LINEAR;
};

// -------------------- VS: �ʒu�ϊ��{PS�p�����̎󂯓n�� --------------------
struct VSIn
{
    float4 pos : POSITION;
    float3 nrm : NORMAL0;
    float2 uv : TEXCOORD0;
};

struct VSOut
{
    float4 pos : POSITION;
    float3 opos : TEXCOORD0; // �I�u�W�F�N�g���W�i=���[���h���W�AWorld=I�z��j
    float3 onrm : TEXCOORD1; // �I�u�W�F�N�g�@��
    float2 uv : TEXCOORD2;
};

VSOut VertexShader1(VSIn i)
{
    VSOut o;
    o.pos = mul(i.pos, g_matWorldViewProj);
    o.opos = i.pos.xyz;
    o.onrm = i.nrm;
    o.uv = i.uv;
    return o;
}

// -------------------- PS: �g�U�{�X�y�L�������s�N�Z���Ōv�Z --------------------
float4 PixelShader1(VSOut i) : COLOR0
{
    // �I�u�W�F�N�g��ԂŌv�Z�iWorld=I�̂��߁j�B����World��I�ɂ���Ȃ� here �����[���h�ɍ��킹�ďC���B
    float3 N = normalize(i.onrm);
    float3 L = normalize(g_lightPos.xyz - i.opos);
    float3 V = normalize(g_cameraPos.xyz - i.opos);
    float3 H = normalize(L + V);

    float NdotL = saturate(dot(N, L));
    float NdotH = saturate(dot(N, H));

    float3 albedo = tex2D(textureSampler, i.uv).rgb;

    // �g�U�iLambert�j�{ ��
    float3 diffuse = albedo * NdotL;
    float3 ambient = albedo * g_ambient;

    // �X�y�L�����iBlinn-Phong�j
    float3 spec = g_SpecColor * (pow(NdotH, g_SpecPower) * g_SpecIntensity);

    float3 color = ambient + diffuse + spec;
    return float4(saturate(color), 1.0f);
}

technique Technique1
{
    pass P0
    {
        // SHADEMODE = FLAT;
        VertexShader = compile vs_3_0 VertexShader1();
        PixelShader = compile ps_3_0 PixelShader1();
    }
}
