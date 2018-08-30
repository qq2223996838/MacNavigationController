//
//  AppVCsWindowController.m
//  MacNavigation
//
//  Created by mooer on 2018/8/30.
//  Copyright © 2018年 mooer. All rights reserved.
//

#import "AppVCsWindowController.h"

#import "NSWindow1Controller.h"

@interface AppVCsWindowController ()

@end

@implementation AppVCsWindowController

- (void)setupToolbar{
    //这里label 是指名字 和 图片名字
    [self addView:self.generalPreferenceView label:@"General" imageUrl:@"General"];
    [self addView:self.colorsPreferenceView label:@"Colors" imageUrl:@"Colors"];
    [self addView:self.playbackPreferenceView label:@"Playback" imageUrl:@"Playback"];
    [self addView:self.updatesPreferenceView label:@"Updates" imageUrl:@"Updates"];
    [self addFlexibleSpacer];
    [self addView:self.advancedPreferenceView label:@"Advanced" imageUrl:@"Advanced"];
    
    // Optional configuration settings.
    [self setCrossFade:[[NSUserDefaults standardUserDefaults] boolForKey:@"fade"]];
    [self setShiftSlowsAnimation:[[NSUserDefaults standardUserDefaults] boolForKey:@"shiftSlowsAnimation"]];
}


- (IBAction)ToView:(id)sender {
    
    _nextWindowController = [[NSWindow1Controller alloc] initWithWindowNibName:NSStringFromClass([NSWindow1Controller class])];
    
    //让显示的位置居于屏幕的中心
    [[_nextWindowController window] center];
    
    //显示需要跳转的窗口
    [_nextWindowController.window orderFront:nil];
    
    //关闭当前窗口
    [self.window orderOut:nil];
    
    
}


@end
