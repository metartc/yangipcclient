/*
 * YangIosRender.h
 *
 *  Created on: 2025年9月25日
 *      Author: yang
 */

#ifndef SRC_YANGIOS_YANGIOSRENDER_H_
#define SRC_YANGIOS_YANGIOSRENDER_H_

#import "YangOpenGLView.h"

#import "yangclient8/yangclient8.h"

@interface YangIosRender:NSObject
{
    @public
    bool m_isStart;
    bool m_isLoop;
    bool m_isRender;
}
-(id)init;
-(void)dealloc;

-(void)start;
-(void)stop;
-(void)render;
-(void)startLoop;
-(void)run;
-(void)setOpengl:(YangOpenGLView*)view;
-(void)setClient:(YangIpcClient8*) iosClient;
@end


#endif /* SRC_YANGIOS_YANGIOSRENDER_H_ */
