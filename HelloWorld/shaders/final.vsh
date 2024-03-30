#version 420 compatibility

varying vec4 texcoord;
uniform int worldTime;

varying float isNight;

void main() {
    gl_Position = ftransform();
    texcoord = gl_TextureMatrix[0] * gl_MultiTexCoord0;

        // ��ҹ�����ֵ
    isNight = 0;  // ����
    if(12000<worldTime && worldTime<13000) {
        isNight = 1.0 - (13000-worldTime) / 1000.0; // ����
    }
    else if(13000<=worldTime && worldTime<=23000) {
        isNight = 1.0;    // ����
    }
    else if(23000<worldTime) {
        isNight = (24000-worldTime) / 1000.0;   // ����
    }
}