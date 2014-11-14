//
//  CCEffectInvert.m
//  cocos2d-ios
//
//  Created by Nicky Weber on 10/27/14.
//
//

#import "CCEffectInvert.h"
#import "CCEffect_Private.h"


@interface CCEffectInvertImpl : CCEffectImpl

@end

@implementation CCEffectInvertImpl

-(id)init
{
    NSArray *fragFunctions = [CCEffectInvertImpl buildFragmentFunctions];
    NSArray *renderPasses = [self buildRenderPasses];
    
    if((self = [super initWithRenderPasses:renderPasses fragmentFunctions:fragFunctions vertexFunctions:nil fragmentUniforms:nil vertexUniforms:nil varyings:nil]))
    {
        self.debugName = @"CCEffectInvertImpl";
    }
    return self;
}

+ (NSArray *)buildFragmentFunctions
{
    NSString* effectBody = CC_GLSL(
            vec4 color = cc_FragColor * texture2D(cc_PreviousPassTexture, cc_FragTexCoord1);
            return vec4((vec3(1.0) - color.rgb) * color.a, color.a);
    );

    CCEffectFunction* fragmentFunction = [[CCEffectFunction alloc] initWithName:@"invertEffect"
                                                                           body:effectBody
                                                                         inputs:nil
                                                                     returnType:@"vec4"];

    return @[fragmentFunction];
}

- (NSArray *)buildRenderPasses
{
    CCEffectRenderPass *pass0 = [[CCEffectRenderPass alloc] init];
    pass0.debugLabel = @"CCEffectInvert pass 0";
    pass0.shader = self.shader;
    pass0.blendMode = [CCBlendMode premultipliedAlphaMode];
    pass0.beginBlocks = @[[^(CCEffectRenderPass *pass, CCEffectRenderPassInputs *passInputs)
    {
        passInputs.shaderUniforms[CCShaderUniformMainTexture] = passInputs.previousPassTexture;
        passInputs.shaderUniforms[CCShaderUniformPreviousPassTexture] = passInputs.previousPassTexture;
    } copy]];
    
    return @[pass0];
}

@end


@implementation CCEffectInvert

-(id)init
{
    if((self = [super init]))
    {
        self.effectImpl = [[CCEffectInvertImpl alloc] init];
        self.debugName = @"CCEffectInvert";
    }
    return self;
}

+(id)effect
{
    return [[self alloc] init];
}

@end

