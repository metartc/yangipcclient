//
// Copyright (c) 2019-2023 yanggaofeng
//


//#include <yangutil/yangtype.h>
#import <UIKit/UIKit.h>

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/EAGL.h>
#include <sys/time.h>


@interface YangGlView : UIView
{

    EAGLContext             *m_glContext;
    GLuint                  m_framebuffer;
    GLuint                  m_renderBuffer;
    GLuint                  m_program;
    GLuint                  m_textureYUV[3];
    GLuint                  m_videoW;
    GLuint                  m_videoH;
    GLsizei                 m_viewScale;

}
#pragma mark - 接口
- (void)playVideo:(uint32_t)width height:(uint32_t)height data:(uint8_t*)data;
- (void)setVideoSize:(GLuint)width height:(GLuint)height;
/** 
 清除画面
 */
- (void)clearFrame;

@end
