#version 420 compatibility

attribute vec2 mc_Entity;

uniform mat4 gbufferProjection;
uniform mat4 gbufferProjectionInverse;
uniform mat4 gbufferModelView;
uniform mat4 gbufferModelViewInverse;

uniform vec3 cameraPosition;

uniform int worldTime;

varying float id;

varying vec3 normal;

varying vec4 texcoord;
varying vec4 lightMapCoord;
varying vec4 color;


vec4 getBump(vec4 positionInViewCoord) {
    vec4 positionInWorldCoord = gbufferModelViewInverse * positionInViewCoord;  // “我的世界坐标”
    positionInWorldCoord.xyz += cameraPosition; // 世界坐标（绝对坐标）

    // 计算凹凸
    positionInWorldCoord.y += sin(float(worldTime*0.3) + positionInWorldCoord.z * 2) * 0.05;

    positionInWorldCoord.xyz -= cameraPosition; // 转回 “我的世界坐标”
    return gbufferModelView * positionInWorldCoord; // 返回眼坐标
}

void main() {
    vec4 positionInViewCoord = gl_ModelViewMatrix * gl_Vertex;   // mv变换计算眼坐
    if(mc_Entity.x >= 10090.99&&mc_Entity.x <= 10091.01) {  // 如果是水则计算凹凸
        gl_Position = gbufferProjection * getBump(positionInViewCoord);  // p变换
    } else {    // 否则直接传递坐标
        gl_Position = gbufferProjection * positionInViewCoord;  // p变换
    }

    color = gl_Color;   // 基色
    id = mc_Entity.x;   // 方块id
    normal = gl_NormalMatrix * gl_Normal;   // 眼坐标系中的法线
    lightMapCoord = gl_TextureMatrix[1] * gl_MultiTexCoord1;    // 光照纹理坐标
    texcoord = gl_TextureMatrix[0] * gl_MultiTexCoord0; // 纹理坐标
}