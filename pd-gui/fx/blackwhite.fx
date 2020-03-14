texture screenSource;

sampler TextureSampler = sampler_state
{
    Texture = <screenSource>;
	MinFilter = Linear;
    MagFilter = Linear;
    MipFilter = Linear;
    AddressU = Wrap;
    AddressV = Wrap;
};

float4 PixelShaderFunction(float2 TextureCoordinate : TEXCOORD0) : COLOR0
{	
    float4 color = tex2D(TextureSampler, TextureCoordinate);
	
	float value = (color.r + color.g + color.b) / 8; 
    color.r = value;
    color.g = value;
    color.b = value;
	
    return color;
}
 
 technique BW
{
    pass Pass1
    {
        PixelShader = compile ps_2_0 PixelShaderFunction();
    }
}
