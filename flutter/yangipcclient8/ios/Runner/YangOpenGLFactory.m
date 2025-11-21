#import "YangOpenGLFactory.h"


@interface FlutterPlatformViewWrapper : NSObject <FlutterPlatformView>
- (YangOpenGLView*) getYangOpenglView;
@property(nonatomic, strong) YangOpenGLView *view;
@end

@implementation FlutterPlatformViewWrapper

- (instancetype)initWithFrame:(CGRect)frame viewId:(int64_t)viewId {
    self = [super init];
    if (self) {
        _view = [[YangOpenGLView alloc] initWithFrame:frame];
    }
    return self;
}

- (UIView *)view {
    return _view;
}
- (YangOpenGLView*) getYangOpenglView{
    return _view;
}
@end

@interface YangOpenGLFactory ()
@property(nonatomic, strong) NSObject<FlutterBinaryMessenger> *messenger;
@end

@implementation YangOpenGLFactory
{
    //YangOpenGLView* m_view;
    NSObject<FlutterBinaryMessenger>* _messenger;
    NSMutableDictionary *_views;
}


- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    if (self) {
        _messenger = messenger;
        _views = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id)args {

    FlutterPlatformViewWrapper* wrap=[[FlutterPlatformViewWrapper alloc] initWithFrame:frame viewId:viewId];
   
    _views[@(viewId)] = wrap;

    NSLog(@"[Native] YangNativeView created: %lld", viewId);
    return wrap;
}

- (YangOpenGLView *)getViewById:(NSNumber *)viewId {
    return [_views[viewId] getYangOpenglView];
}

@end
