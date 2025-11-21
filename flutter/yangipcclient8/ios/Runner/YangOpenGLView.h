//
// Copyright (c) 2019-2025 yanggaofeng
//


#import <UIKit/UIKit.h>

@interface YangOpenGLView : UIView
{

@public
  bool m_isStart;

}

- (void)intiPlay;
- (void)closePlay;
- (void)setLoglevel:(int)logLevel;
- (void)setDecodeHw:(int)isHw;
- (void)setIceConfig:(int)iceTransportPolicy iceCandidateType:(int)iceCandidateType;
- (void)playVideo:(uint32_t)width height:(uint32_t)height data:(uint8_t*)data;
- (void)setVideoSize:(uint32_t)width height:(uint32_t)height;
- (void)play:(NSString *)serverTopic;
- (void)unplay;
- (void)setMqttServer:(NSString *)ip port:(int)port username:(NSString *)username password:(NSString *)password;
- (void)setIceServer:(NSString *)ip port:(int)port username:(NSString *)username password:(NSString *)password;
/**
 清除画面
 */
- (void)clearFrame;

@end
