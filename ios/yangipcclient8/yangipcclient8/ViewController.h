//
//  ViewController.h
//  metaplayer7_ios
//
//  Created by apple on 2023/8/14.
//  Copyright © 2023 metaRTC. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "YangGlView.h"
#import "YangIosClient.h"
#import "YangIosRender.h"
@interface ViewController : UIViewController
{
    @public
    YangGlView *m_glview;
    bool m_isStart;
    //yangbool m_isRender;

    YangIosClient *m_client;
    YangIosRender* m_render;
}

-(id)init;
//-(void)dealloc;
@property (weak, nonatomic) IBOutlet UIButton *m_b_play;

@property (weak, nonatomic) IBOutlet UIButton *m_b_set;

//@property (weak, nonatomic) IBOutlet UITextField *m_t_url;

//@property (nonatomic, retain) YangGlView *m_glview;

@property (weak, nonatomic) IBOutlet UIView *m_play_view;

-(void)on_play;

@end

