/*
 * YangOpenGLFactory.h
 *
 *  Created on: 2025年9月25日
 *      Author: yang
 */

#ifndef SRC_YANGIOS_YangOpenGLFactory_H_
#define SRC_YANGIOS_YangOpenGLFactory_H_

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>
#import "YangOpenGLView.h"

@interface YangOpenGLFactory : NSObject <FlutterPlatformViewFactory>

- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
- (YangOpenGLView *)getViewById:(NSNumber *)viewId;
@end




#endif /* SRC_YANGIOS_YangOpenGLFactory_H_ */
