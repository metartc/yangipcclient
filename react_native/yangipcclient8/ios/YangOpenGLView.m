//
// Copyright (c) 2019-2023 yanggaofeng
//

#import "YangOpenGLView.h"

#import "yangclient8/yangclient8.h"
#import "YangIosRender.h"

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/EAGL.h>
#include <sys/time.h>


enum AttribEnum
{
    ATTRIB_VERTEX,
    ATTRIB_TEXTURE,
    ATTRIB_COLOR,
};

//YUV数据枚举
enum TextureType
{
    TEXY = 0,
    TEXU,
    TEXV,
    TEXC
};



static void yang_success(void* session){
    //ViewController* view=(__bridge ViewController*)session;
    //if(view->m_isStart)
       // return;
    
   // [view on_play];
}

static void yang_failure(void* session,int32_t  errcode){
  YangOpenGLView* view=(__bridge YangOpenGLView*)session;
    if(errcode==3){
        if(view->m_isStart){
            [view unplay];
        }
        return;
    }

}

@implementation YangOpenGLView
{
  bool m_isInited;

  YangIpcClient8 *m_client;
  YangIosRender* m_render;
  YangPlayerMsgCallback m_callback;
  
  EAGLContext             *m_glContext;
  GLuint                  m_framebuffer;
  GLuint                  m_renderBuffer;
  GLuint                  m_program;
  GLuint                  m_textureYUV[3];
  GLuint                  m_videoW;
  GLuint                  m_videoH;
  GLsizei                 m_viewScale;
}

- (void)initPlay{
  if(m_isInited)
      return;

  if(m_client==NULL) {
    m_callback.session=(__bridge void*)self;
    m_callback.success=yang_success;
    m_callback.failure=yang_failure;
    m_client=(YangIpcClient8*)calloc(sizeof(YangIpcClient8),1);
    yang_create_ipcClient8(m_client,&m_callback,yangtrue);
    m_client->init(m_client->session);
  }
      
  if(m_render==NULL){
      m_render=[[YangIosRender alloc] init];
      [m_render setOpengl:self];
      [m_render setClient:m_client];
  }

  m_isInited=true;
}

- (void)closePlay{

  yang_destroy_ipcClient8(m_client);
  if(m_client){
      free(m_client);
  }

  m_client=NULL;
}

- (void)play:(NSString *)serverTopic{
  if(m_isStart) return;
  [self initPlay];

  if(m_client){
    if(m_client->startMqtt(m_client->session,(char*)[serverTopic UTF8String]))
      return;
    if(!m_client->mqttALive(m_client->session))
        return;
    if(m_client->startPlay(m_client->session)!=0)
          return;
      
    if(!m_render->m_isRender){
        m_render->m_isRender=true;
        [m_render start];
    }
  }

  m_isStart=true;
     
}

- (void)unplay{
  if(!m_isStart) return;
  m_isStart=false;

  m_client->stopPlay(m_client->session);
  m_render->m_isRender=false;

}

- (void)setLoglevel:(int)logLevel{
  [self initPlay];
  m_client->setLoglevel(m_client->session,logLevel);
}

- (void)setDecodeHw:(int)isHw{
  [self initPlay];
  m_client->setDecodeHw(m_client->session,isHw);
}

- (void)setIceConfig:(int)iceTransportPolicy iceCandidateType:(int)iceCandidateType{
  [self initPlay];
  m_client->setIceConfig(m_client->session,iceTransportPolicy, iceCandidateType);
}

- (void)setMqttServer:(NSString *)ip
                      port:(int)port
                  username:(NSString *)username
                  password:(NSString *)password
{
  [self initPlay];
  m_client->setMqttServer(m_client->session,yangfalse,
                    (char*)[ip UTF8String], port,
                    (char*)[username UTF8String], (char*)[password UTF8String]);
}

- (void)setIceServer:(NSString *)ip
                      port:(int)port
                  username:(NSString *)username
                  password:(NSString *)password
{
  [self initPlay];
  m_client->setIceServer(m_client->session,
                        (char*)[ip UTF8String], port,
                        (char*)[username UTF8String], (char*)[password UTF8String]);
    
}

#pragma mark -  初始化等操作
- (BOOL)doInit{
  m_isInited=false;
  m_isStart=false;

  m_client=NULL;
  m_render=NULL;

  // 用来显示opengl的图形
  CAEAGLLayer *eaglLayer = (CAEAGLLayer*) self.layer;

  
  // 设为不透明 -> NO（必须）
  eaglLayer.opaque = NO;
  eaglLayer.backgroundColor = [UIColor clearColor].CGColor;

  // 使用带 alpha 的 color format：RGBA8（必须）
  eaglLayer.drawableProperties = @{
      kEAGLDrawablePropertyRetainedBacking: @NO,
      kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8
  };

  // 设置分辨率
  self.contentScaleFactor = [UIScreen mainScreen].scale;
  m_viewScale = [UIScreen mainScreen].scale;

  // 创建上下文
  m_glContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
  if(!m_glContext || ![EAGLContext setCurrentContext:m_glContext]) {
      return NO;
  }

  // 启用混合以支持 alpha 叠加
  glEnable(GL_BLEND);
  glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

  // 创建纹理 / 着色器等
  [self setupYUVTexture];
  [self loadShader];

  glPixelStorei(GL_UNPACK_ALIGNMENT, 4);
  glUseProgram(m_program);

  GLuint textureUniformY = glGetUniformLocation(m_program, "SamplerY");
  GLuint textureUniformU = glGetUniformLocation(m_program, "SamplerU");
  GLuint textureUniformV = glGetUniformLocation(m_program, "SamplerV");
  glUniform1i(textureUniformY, 0);
  glUniform1i(textureUniformU, 1);
  glUniform1i(textureUniformV, 2);

  return YES;
}



-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if (![self doInit]) {
            self = nil;
            return nil;
        }
        // UIView 也设为透明
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder{

    self = [super initWithCoder:aDecoder];

    if (self) {

        //没有初始化成功
        if (![self doInit]) {

            self = nil;
        }
    }

    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];

    // 在主线程操作 layer / renderbuffer（保证 renderbufferStorage 正确执行）
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized (self) {
            [EAGLContext setCurrentContext:m_glContext];

            [self destoryFrameAndRenderBuffer];
            [self createFrameAndRenderBuffer];

            // 更新 viewport（注意乘以 scale）
            glViewport(0, 0, (GLsizei)(self.bounds.size.width * m_viewScale),
                       (GLsizei)(self.bounds.size.height * m_viewScale));
        }
    });
}


#pragma mark -  设置opengl

/**
 不写的话,设置描绘属性会崩溃

 @return <#return value description#>
 */
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (void)setupLayer
{
    //m_eaglLayer = (CAEAGLLayer*) self.layer;
   // m_eaglLayer.opaque = YES;
    
}
/**
 创建缓冲区

 @return <#return value description#>
 */
- (BOOL)createFrameAndRenderBuffer
{
    //创建帧缓冲绑定
    glGenFramebuffers(1, &m_framebuffer);
    //创建渲染缓冲
    glGenRenderbuffers(1, &m_renderBuffer);

    //将之前用glGenFramebuffers创建的帧缓冲绑定为当前的Framebuffer(绑定到context上？).
    glBindFramebuffer(GL_FRAMEBUFFER, m_framebuffer);
    //Renderbuffer绑定到context上,此时当前Framebuffer完全由renderbuffer控制
    glBindRenderbuffer(GL_RENDERBUFFER, m_renderBuffer);

    //分配空间
    if (![m_glContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:(CAEAGLLayer *)self.layer])
    {
        NSLog(@"attach渲染缓冲区失败");
    }

    //这个函数看起来有点复杂，但其实它很好理解的。它要做的全部工作就是把把前面我们生成的深度缓存对像与当前的FBO对像进行绑定，当然我们要注意一个FBO有多个不同绑定点，这里是要绑定在FBO的深度缓冲绑定点上。
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, m_renderBuffer);

    //检查当前帧缓存的关联图像和帧缓存参数
    if (glCheckFramebufferStatus(GL_FRAMEBUFFER) != GL_FRAMEBUFFER_COMPLETE)
    {
        NSLog(@"创建缓冲区错误 0x%x", glCheckFramebufferStatus(GL_FRAMEBUFFER));
        return NO;
    }
    return YES;
}

/**
 清除缓冲区
 */
- (void)destoryFrameAndRenderBuffer
{
    if (m_framebuffer)
    {
        //删除FBO
        glDeleteFramebuffers(1, &m_framebuffer);
    }

    if (m_renderBuffer)
    {
        //删除渲染缓冲区
        glDeleteRenderbuffers(1, &m_renderBuffer);
    }

    m_framebuffer = 0;
    m_renderBuffer = 0;
}
/**
 创建纹理
 */
- (void)setupYUVTexture{

    if (m_textureYUV[TEXY])
    {
        //删除纹理
        glDeleteTextures(3, m_textureYUV);
    }

    //生成纹理
    glGenTextures(3, m_textureYUV);
    if (!m_textureYUV[TEXY] || !m_textureYUV[TEXU] || !m_textureYUV[TEXV])
    {
        NSLog(@"<<<<<<<<<<<<纹理创建失败!>>>>>>>>>>>>");
        return;
    }

    //选择当前活跃单元
    glActiveTexture(GL_TEXTURE0);
    //绑定Y纹理
    glBindTexture(GL_TEXTURE_2D, m_textureYUV[TEXY]);
    //纹理过滤函数
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);//放大过滤
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);//缩小过滤
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);//水平方向
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);//垂直方向

    glActiveTexture(GL_TEXTURE1);
    glBindTexture(GL_TEXTURE_2D, m_textureYUV[TEXU]);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

    glActiveTexture(GL_TEXTURE2);
    glBindTexture(GL_TEXTURE_2D, m_textureYUV[TEXV]);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

}

#define FSH @"varying lowp vec2 TexCoordOut;\
\
uniform sampler2D SamplerY;\
uniform sampler2D SamplerU;\
uniform sampler2D SamplerV;\
\
void main(void)\
{\
mediump vec3 yuv;\
lowp vec3 rgb;\
\
yuv.x = texture2D(SamplerY, TexCoordOut).r;\
yuv.y = texture2D(SamplerU, TexCoordOut).r - 0.5;\
yuv.z = texture2D(SamplerV, TexCoordOut).r - 0.5;\
\
rgb = mat3( 1,       1,         1,\
0,       -0.39465,  2.03211,\
1.13983, -0.58060,  0) * yuv;\
\
gl_FragColor = vec4(rgb, 1);\
\
}"

#define VSH @"attribute vec4 position;\
attribute vec2 TexCoordIn;\
varying vec2 TexCoordOut;\
\
void main(void)\
{\
gl_Position = position;\
TexCoordOut = TexCoordIn;\
}"

/**
 加载着色器
 */
- (void)loadShader{
    /**
     1 编译着色
     */
    GLuint vertexShader = [self compileShader:VSH withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:FSH withType:GL_FRAGMENT_SHADER];

    /**
     2
     */
    //创建程序容器
    m_program = glCreateProgram();
    //绑定shader到program
    glAttachShader(m_program, vertexShader);
    glAttachShader(m_program, fragmentShader);

    /**
     绑定需要在link之前
     */
    //把顶点属性索引绑定到顶点属性名
    glBindAttribLocation(m_program, ATTRIB_VERTEX, "position");
    glBindAttribLocation(m_program, ATTRIB_TEXTURE, "TexCoordIn");

    //链接
    glLinkProgram(m_program);

    /**
     3
     */
    GLint linkSuccess;
    //查询相关信息,并将数据返回到linkSuccess
    glGetProgramiv(m_program, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(m_program, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"<<<<着色器连接失败 %@>>>", messageString);
        //exit(1);
    }

    if (vertexShader)
    /*
     释放内存不能立刻删除
     If a shader object to be deleted is attached to a program object, it will be flagged for deletion, but it will not be deleted until it is no longer attached to any program object…
     shader 删除该着色器对象（如果一个着色器对象在删除前已经链接到程序对象中，那么当执行glDeleteShader函数时不会立即被删除，而是该着色器对象将被标记为删除，器内存被释放一次，它不再链接到其他任何程序对象）
     */
        glDeleteShader(vertexShader);
    if (fragmentShader)
        glDeleteShader(fragmentShader);
}

/**
 编译着色代码,使用着色器

 @param shaderString 代码
 @param shaderType   类型

 @return 成功返回着色器,失败返回-1
 */
- (GLuint)compileShader:(NSString*)shaderString withType:(GLenum)shaderType
{

    /**
     1
     */
    if (!shaderString) {
        //        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    else
    {
        //NSLog(@"shader code-->%@", shaderString);
    }

    /**
     2 分别创建一个顶点着色器对象和一个片段着色器对象
     */
    GLuint shaderHandle = glCreateShader(shaderType);

    /**
     3 分别将顶点着色程序的源代码字符数组绑定到顶点着色器对象，将片段着色程序的源代码字符数组绑定到片段着色器对象
     */
    const char * shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = (int)[shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);

    /**
     4 分别编译顶点着色器对象和片段着色器对象
     */
    glCompileShader(shaderHandle);

    /**
     5
     */
    GLint compileSuccess;

    //获取编译情况
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }

    return shaderHandle;
}

#pragma mark -  接口



/**
 设置大小

 @param width  界面宽
 @param height 界面高
 */
-(void)setVideoSize:(GLuint)width height:(GLuint)height{

    //给宽高赋值
    m_videoH = height;
    m_videoW = width;

    //开辟内存空间
    //为什么乘1.5而不是1: width * hight =Y（总和） U = Y / 4   V = Y / 4
    void *blackData = malloc(width * height * 1.5);

    if (blackData) {

        /**
         对内存空间清零,作用是在一段内存块中填充某个给定的值，它是对较大的结构体或数组进行清零操作的一种最快方法

         @param __b#>   源数据 description#>
         @param __c#>   填充数据 description#>
         @param __len#> 长度 description#>

         @return <#return value description#>
         */
        memset(blackData, 0x0, width * height * 1.5);
    }
    /*
     Apple平台不允许直接对Surface进行操作.这也就意味着在Apple中,不能通过调用eglSwapBuffers函数来直接实现渲染结果在目标surface上的更新.
     在Apple平台中,首先要创建一个EAGLContext对象来替代EGLContext (不能通过eglCreateContext来生成), EAGLContext的作用与EGLContext是类似的.
     然后,再创建相应的Framebuffer和Renderbuffer.
     Framebuffer象一个Renderbuffer集(它可以包含多个Renderbuffer对象).

     Renderbuffer有三种:  color Renderbuffer, depth Renderbuffer, stencil Renderbuffer.

     渲染结果是先输出到Framebuffer中,然后通过调用context的presentRenderbuffer,将Framebuffer上的内容提交给之前的CustumView.
     */

    //设置当前上下文
    [EAGLContext setCurrentContext:m_glContext];


    /*
     target —— 纹理被绑定的目标，它只能取值GL_TEXTURE_1D、GL_TEXTURE_2D、GL_TEXTURE_3D或者GL_TEXTURE_CUBE_MAP；
     texture —— 纹理的名称，并且，该纹理的名称在当前的应用中不能被再次使用。
     glBindTexture可以让你创建或使用一个已命名的纹理，调用glBindTexture方法，将target设置为GL_TEXTURE_1D、GL_TEXTURE_2D、GL_TEXTURE_3D或者GL_TEXTURE_CUBE_MAP，并将texture设置为你想要绑定的新纹理的名称，即可将纹理名绑定至当前活动纹理单元目标。当一个纹理与目标绑定时，该目标之前的绑定关系将自动被打破。纹理的名称是一个无符号的整数。在每个纹理目标中，0被保留用以代表默认纹理。纹理名称与相应的纹理内容位于当前GL rendering上下文的共享对象空间中。
     */

    //绑定Y纹理
    glBindTexture(GL_TEXTURE_2D, m_textureYUV[TEXY]);


    /**
     根据像素数据,加载纹理

     @param target#>         指定目标纹理，这个值必须是GL_TEXTURE_2D。 description#>
     @param level#>          执行细节级别。0是最基本的图像级别，n表示第N级贴图细化级别 description#>
     @param internalformat#> 指定纹理中的颜色格式。可选的值有GL_ALPHA,GL_RGB,GL_RGBA,GL_LUMINANCE, GL_LUMINANCE_ALPHA 等几种。 description#>
     @param width#>          纹理的宽度 description#>
     @param height#>         高度 description#>
     @param border#>         纹理的边框宽度,必须为0 description#>
     @param format#>         像素数据的颜色格式, 不需要和internalformatt取值必须相同。可选的值参考internalformat。 description#>
     @param type#>           指定像素数据的数据类型。可以使用的值有GL_UNSIGNED_BYTE,GL_UNSIGNED_SHORT_5_6_5,GL_UNSIGNED_SHORT_4_4_4_4,GL_UNSIGNED_SHORT_5_5_5_1等。 description#>
     @param pixels#>         指定内存中指向图像数据的指针 description#>

     @return <#return value description#>
     */
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RED_EXT, width, height, 0, GL_RED_EXT, GL_UNSIGNED_BYTE, blackData);

    //绑定U纹理
    glBindTexture(GL_TEXTURE_2D, m_textureYUV[TEXU]);
    //加载纹理
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RED_EXT, width/2, height/2, 0, GL_RED_EXT, GL_UNSIGNED_BYTE, blackData + width * height);

    //绑定V数据
    glBindTexture(GL_TEXTURE_2D, m_textureYUV[TEXV]);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RED_EXT, width/2, height/2, 0, GL_RED_EXT, GL_UNSIGNED_BYTE, blackData + width * height * 5 / 4);

    //释放malloc分配的内存空间
    free(blackData);
}


/**
 清除画面
 */
-(void)clearFrame {
    if ([self window]) {
        [EAGLContext setCurrentContext:m_glContext];

        // 透明清屏
        glClearColor(0.0, 0.0, 0.0, 0.0);
        glClear(GL_COLOR_BUFFER_BIT);

        glBindRenderbuffer(GL_RENDERBUFFER, m_renderBuffer);
        [m_glContext presentRenderbuffer:GL_RENDERBUFFER];
    }
}



/**
 显示YUV数据
 */
- (void)playVideo:(uint32_t)width height:(uint32_t)height data:(uint8_t*)data{

    if (!self.window) {
        return;
    }
    int w = width;
    int h = height;
    //加互斥锁,防止其他线程访问
    @synchronized (self) {

        if (w != m_videoW || h != m_videoH) {
            [self setVideoSize:(GLuint)w height:(GLuint)h];
        }

        //设置当前上下文
        [EAGLContext setCurrentContext:m_glContext];

        //绑定
        glBindTexture(GL_TEXTURE_2D, m_textureYUV[TEXY]);

        /**
         更新纹理
         @param target#>  指定目标纹理，这个值必须是GL_TEXTURE_2D。 description#>
         @param level#>   执行细节级别。0是最基本的图像级别，n表示第N级贴图细化级别 description#>
         @param xoffset#> 纹理数据的偏移x值 description#>
         @param yoffset#> 纹理数据的偏移y值 description#>
         @param width#>   更新到现在的纹理中的纹理数据的规格宽 description#>
         @param height#>  高 description#>
         @param format#>  像素数据的颜色格式, 不需要和internalformatt取值必须相同。可选的值参考internalformat。 description#>
         @param type#>    颜色分量的数据类型 description#>
         @param pixels#>  指定内存中指向图像数据的指针 description#>

         @return <#return value description#>
         */
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, (GLsizei)w, (GLsizei)h, GL_RED_EXT, GL_UNSIGNED_BYTE, data);

        glBindTexture(GL_TEXTURE_2D, m_textureYUV[TEXU]);
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, (GLsizei)w/2, (GLsizei)h/2, GL_RED_EXT, GL_UNSIGNED_BYTE, data+w*h);

        glBindTexture(GL_TEXTURE_2D, m_textureYUV[TEXV]);
        glTexSubImage2D(GL_TEXTURE_2D, 0, 0, 0, (GLsizei)w/2, (GLsizei)h/2, GL_RED_EXT, GL_UNSIGNED_BYTE, data+5*w*h/4);
        //渲染
        [self render];
    }
}

//渲染
-(void)render{

    //设置上下文
    [EAGLContext setCurrentContext:m_glContext];

    CGSize size = self.bounds.size;

    //把数据显示在这个视窗上
    glViewport(1, 1, size.width * m_viewScale, size.height * m_viewScale);
  // 透明清屏
   glClearColor(0.0, 0.0, 0.0, 0.0);
   glClear(GL_COLOR_BUFFER_BIT);
    /*
     我们如果选定(0, 0), (0, 1), (1, 0), (1, 1)四个纹理坐标的点对纹理图像映射的话，就是映射的整个纹理图片。如果我们选择(0, 0), (0, 1), (0.5, 0), (0.5, 1) 四个纹理坐标的点对纹理图像映射的话，就是映射左半边的纹理图片（相当于右半边图片不要了），相当于取了一张320x480的图片。但是有一点需要注意，映射的纹理图片不一定是“矩形”的。实际上可以指定任意形状的纹理坐标进行映射。下面这张图就是映射了一个梯形的纹理到目标物体表面。这也是纹理（Texture）比上一篇文章中记录的表面（Surface）更加灵活的地方。
     */
    static const GLfloat squareVertices[] = {
        -1.0f, -1.0f,
        1.0f, -1.0f,
        -1.0f,  1.0f,
        1.0f,  1.0f,
    };


    static const GLfloat coordVertices[] = {
        0.0f, 1.0f,
        1.0f, 1.0f,
        0.0f,  0.0f,
        1.0f,  0.0f,
    };

    //更新属性值
    glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
    //开启定点属性数组
    glEnableVertexAttribArray(ATTRIB_VERTEX);


    glVertexAttribPointer(ATTRIB_TEXTURE, 2, GL_FLOAT, 0, 0, coordVertices);
    glEnableVertexAttribArray(ATTRIB_TEXTURE);

    //绘制

    //当采用顶点数组方式绘制图形时，使用该函数。该函数根据顶点数组中的坐标数据和指定的模式，进行绘制。
    //绘制方式,从数组的哪一个点开始绘制(一般为0),顶点个数
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    //将该渲染缓冲区对象绑定到管线上
    glBindRenderbuffer(GL_RENDERBUFFER, m_renderBuffer);

    //把缓冲区（render buffer和color buffer）的颜色呈现到UIView上
    [m_glContext presentRenderbuffer:GL_RENDERBUFFER];

}

- (void)dealloc{
    NSLog(@"gl dealloc");
    [self closePlay];
    [self clearFrame];
    if (m_glContext) {
       // _glContext = nil;
    }
    [self destoryFrameAndRenderBuffer];
}

@end
