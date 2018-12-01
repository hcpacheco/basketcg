#version 330 core

// Atributos de fragmentos recebidos como entrada ("in") pelo Fragment Shader.
// Neste exemplo, este atributo foi gerado pelo rasterizador como a
// interpolação da posição global e a normal de cada vértice, definidas em
// "shader_vertex.glsl" e "main.cpp".
in vec4 position_world;
in vec4 normal;

// Posição do vértice atual no sistema de coordenadas local do modelo.
in vec4 position_model;

in vec3 corCesta;


// Coordenadas de textura obtidas do arquivo OBJ (se existirem!)
in vec2 texcoords;

// Matrizes computadas no código C++ e enviadas para a GPU
uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

// Identificador que define qual objeto está sendo desenhado no momento
#define INVSPHERE   0
#define PLANE       1
#define COW         2
#define CUBEV       3
#define SPHERE      4
#define CESTA       5
#define PLANE2      6
#define BALOON      7
#define COW2        8
#define MOUNTAIN    9

uniform int object_id;

// Parâmetros da axis-aligned bounding box (AABB) do modelo
uniform vec4 bbox_min;
uniform vec4 bbox_max;

// Variáveis para acesso das imagens de textura
uniform sampler2D TextureImage0;
uniform sampler2D TextureImage1;
uniform sampler2D TextureImage2;
uniform sampler2D TextureImage3;
uniform sampler2D TextureImage4;
uniform sampler2D TextureImage5;
uniform sampler2D TextureImage6;

// O valor de saída ("out") de um Fragment Shader é a cor final do fragmento.
out vec3 color;

float ro = 1.0f;
// Constantes
#define M_PI   3.14159265358979323846
#define M_PI_2 1.57079632679489661923

void main()
{
    // Obtemos a posição da câmera utilizando a inversa da matriz que define o
    // sistema de coordenadas da câmera.
    vec4 origin = vec4(0.0, 0.0, 0.0, 1.0);
    vec4 camera_position = inverse(view) * origin;

    // O fragmento atual é coberto por um ponto que percente à superfície de um
    // dos objetos virtuais da cena. Este ponto, p, possui uma posição no
    // sistema de coordenadas global (World coordinates). Esta posição é obtida
    // através da interpolação, feita pelo rasterizador, da posição de cada
    // vértice.
    vec4 p = position_world;

    // Normal do fragmento atual, interpolada pelo rasterizador a partir das
    // normais de cada vértice.
    vec4 n = normalize(normal);

    // Vetor que define o sentido da fonte de luz em relação ao ponto atual.
    vec4 l = normalize(vec4(2.5,2.5,4.0,0.0));

    // Vetor que define o sentido da câmera em relação ao ponto atual.
    vec4 v = normalize(camera_position - p);


    // Coordenadas de textura U e V
    float U = 0.0;
    float V = 0.0;

    if ( object_id == INVSPHERE )
    {
        // PREENCHA AQUI as coordenadas de textura da esfera, computadas com
        // projeção esférica EM COORDENADAS DO MODELO. Utilize como referência
        // o slide 144 do documento "Aula_20_e_21_Mapeamento_de_Texturas.pdf".
        // A esfera que define a projeção deve estar centrada na posição
        // "bbox_center" definida abaixo.

        // Você deve utilizar:
        //   função 'length( )' : comprimento Euclidiano de um vetor
        //   função 'atan( , )' : arcotangente. Veja https://en.wikipedia.org/wiki/Atan2.
        //   função 'asin( )'   : seno inverso.
        //   constante M_PI
        //   variável position_model



        vec4 bbox_center = (bbox_min + bbox_max) / 2.0;

        vec4 c = bbox_center;


        vec4 pl = c + normalize(position_model - c);

        vec4 pv =  pl - c;

        float theta = atan(pv.x,pv.z);
        float phi   = asin(pv.y);



        U = (theta + M_PI)/(2*M_PI);
        V = (phi + M_PI_2)/M_PI;
        /////////////////////////////////////////////////////

        vec3 Kd2 = texture(TextureImage1, vec2(U,V)).rgb;

        //float lambert = max(0,dot(n,l));
        float lambert = 0.99;

        color = Kd2 * (lambert + 0.01);
        //////////////////////////////////////////////////
    }
    else if ( object_id == SPHERE )
    {
        // PREENCHA AQUI as coordenadas de textura da esfera, computadas com
        // projeção esférica EM COORDENADAS DO MODELO. Utilize como referência
        // o slide 144 do documento "Aula_20_e_21_Mapeamento_de_Texturas.pdf".
        // A esfera que define a projeção deve estar centrada na posição
        // "bbox_center" definida abaixo.

        // Você deve utilizar:
        //   função 'length( )' : comprimento Euclidiano de um vetor
        //   função 'atan( , )' : arcotangente. Veja https://en.wikipedia.org/wiki/Atan2.
        //   função 'asin( )'   : seno inverso.
        //   constante M_PI
        //   variável position_model



        vec4 bbox_center = (bbox_min + bbox_max) / 2.0;

        vec4 c = bbox_center;


        vec4 pl = c + normalize(position_model - c);

        vec4 pv =  pl - c;

        float theta = atan(pv.x,pv.z);
        float phi   = asin(pv.y);



        U = (theta + M_PI)/(2*M_PI);
        V = (phi + M_PI_2)/M_PI;
        /////////////////////////////////////////////////////

        vec3 Kd2 = texture(TextureImage2, vec2(U,V)).rgb;

        float lambert = max(0,dot(n,l));

        color = Kd2 * (lambert + 0.01);
        //////////////////////////////////////////////////
    }
    else if ( object_id == COW)
    {
        // PREENCHA AQUI as coordenadas de textura do coelho, computadas com
        // projeção planar XY em COORDENADAS DO MODELO. Utilize como referência
        // o slide 111 do documento "Aula_20_e_21_Mapeamento_de_Texturas.pdf",
        // e também use as variáveis min*/max* definidas abaixo para normalizar
        // as coordenadas de textura U e V dentro do intervalo [0,1]. Para
        // tanto, veja por exemplo o mapeamento da variável 'p_v' utilizando
        // 'h' no slide 154 do documento "Aula_20_e_21_Mapeamento_de_Texturas.pdf".
        // Veja também a Questão 4 do Questionário 4 no Moodle.

        float minx = bbox_min.x;
        float maxx = bbox_max.x;

        float miny = bbox_min.y;
        float maxy = bbox_max.y;

        float minz = bbox_min.z;
        float maxz = bbox_max.z;

        U = (position_model.x - minx) / (maxx - minx);
        V = (position_model.y - miny) / (maxy - miny);


        vec3 Kd2 = texture(TextureImage0, vec2(U,V)).rgb;


        float lambert = max(0,dot(n,l));

        color = Kd2 * (lambert + 0.01);


    }
    else if(object_id == COW2)
    {
        float minx = bbox_min.x;
        float maxx = bbox_max.x;

        float miny = bbox_min.y;
        float maxy = bbox_max.y;

        float minz = bbox_min.z;
        float maxz = bbox_max.z;

        U = (position_model.x - minx) / (maxx - minx);
        V = (position_model.y - miny) / (maxy - miny);


        vec3 Kd2 = texture(TextureImage6, vec2(U,V)).rgb;


        float lambert = max(0,dot(n,l));

        color = Kd2 * (lambert + 0.01);

    }
    else if ( object_id == PLANE || object_id == MOUNTAIN )
    {
        // Coordenadas de textura do plano, obtidas do arquivo OBJ.
        U = texcoords.x;
        V = texcoords.y;



        vec3 Kd2 = texture(TextureImage3, vec2(U,V)).rgb;

        float lambert = max(0,dot(n,l));

        //color = Kd2 * (lambert + 0.01);
        color = Kd2;
    }

    else if ( object_id == CUBEV )
    {
        // Coordenadas de textura do plano, obtidas do arquivo OBJ.

        float minx = bbox_min.x;
        float maxx = bbox_max.x;

        float miny = bbox_min.y;
        float maxy = bbox_max.y;

        float minz = bbox_min.z;
        float maxz = bbox_max.z;

        U = (position_model.x - minx) / (maxx - minx);
        V = (position_model.y - miny) / (maxy - miny);

        vec3 Kd2 = texture(TextureImage4, vec2(U,V)).rgb;

        //float lambert = max(0,dot(n,l));
        float lambert = 0.8;

        color = Kd2 * (lambert + 0.01);

    }
    else if ( object_id == CESTA)
    {
        color = corCesta;
    }

    else if (object_id == PLANE2)
    {
        vec4 h = normalize(l+v);

        // Coordenadas de textura do plano, obtidas do arquivo OBJ.
        float U = texcoords.x;
        float V = texcoords.y;


        vec3 Ks = vec3(0.44,0.29,0.15);
        vec3 Ka = vec3(0.04,0.03,0.03);
        float q = 60.0;

        // Espectro da fonte de iluminação
        vec3 I = vec3(1.0,1.0,1.0);

        // Espectro da luz ambiente
        vec3 Ia = vec3(0.5,0.5,0.5);

        vec3 Kd2 = texture(TextureImage4, vec2(U,V)).rgb;


        // Termo difuso utilizando a lei dos cossenos de Lambert
        vec3 lambert_diffuse_term = Kd2*I*max(0,dot(n,l));

        // Termo ambient
        vec3 ambient_term = Ka * Ia;

        // Termo especular utilizando o modelo de iluminação de Phong
        float x = pow( max( 0,dot(n,h) ), q );

        vec3 phong_specular_term = Ks*I*x;



        color = (lambert_diffuse_term + ambient_term + phong_specular_term)*1.3;
    }
    else if(object_id == BALOON)
    {

        float lambert = max(0,dot(n,l));
        color = vec3(0.5,0.05,0.15) * (lambert);
        //corCesta = vec3(1.0,1.0,1.0);
    }
//    else if(object_id == MOUNTAIN)
//    {
//        color = vec3(0.5,0.5,0.5);
//    }


    // Cor final com correção gamma, considerando monitor sRGB.
    // Veja https://en.wikipedia.org/w/index.php?title=Gamma_correction&oldid=751281772#Windows.2C_Mac.2C_sRGB_and_TV.2Fvideo_standard_gammas
    color = pow(color, vec3(1.0,1.0,1.0)/2.2);
}

