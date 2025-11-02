//
// Copyright (c) 2019-2022 yanggaofeng
//
#ifndef YangPlayWidget_H
#define YangPlayWidget_H

#include <QOpenGLWidget>
#include <QOpenGLShaderProgram>
#include <QOpenGLFunctions>
#include <QOpenGLTexture>

#define Yang_Ok 0
#define yangtrue true
#define yangfalse false
#define YANGALIGN(x, a) (((x)+(a)-1)&~((a)-1))
#define yang_delete(a) {if( (a)) {delete (a); (a) = NULL;}}
#define yang_deleteA(a) {if( (a)) {delete[] (a); (a) = NULL;}}
#define yang_error printf
#define yang_trace printf
#define ATTRIB_VERTEX 3
#define ATTRIB_TEXTURE 4

class YangPlayWidget : public QOpenGLWidget, protected QOpenGLFunctions
{
    Q_OBJECT
public:
    YangPlayWidget(QWidget* parent);
    virtual ~YangPlayWidget();
     void playVideo(unsigned char *p,int wid,int hei);
protected:
    void initializeGL() Q_DECL_OVERRIDE;
    void resizeGL(int w, int h) Q_DECL_OVERRIDE;
    void paintGL() Q_DECL_OVERRIDE;
private:
    GLuint textureUniformY;
    GLuint textureUniformU;
    GLuint textureUniformV;
    GLuint id_y;
    GLuint id_u;
    GLuint id_v;
    QOpenGLTexture* m_textureY;
    QOpenGLTexture* m_textureU;
    QOpenGLTexture* m_textureV;
    QOpenGLShader *m_vshader;
    QOpenGLShader *m_fshader;
    QOpenGLShaderProgram *m_shaderProgram;
    int m_nVideoW;
    int m_nVideoH;
    unsigned char* m_pBufYuv420p;

};

#endif // CPLAYWIDGET_H
