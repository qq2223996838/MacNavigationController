//
//  NSWindow1Controller.m
//  MacNavigationController
//
//  Created by mooer on 2018/8/30.
//  Copyright © 2018年 mooer. All rights reserved.
//

#import "NSWindow1Controller.h"
#import "NSWindow2Controller.h"


@interface NSWindow1Controller ()

@end

@implementation NSWindow1Controller

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    self.window.backgroundColor = [NSColor redColor];
    
}

- (IBAction)view1:(id)sender {
    
    _nextWindowController = [[NSWindow2Controller alloc] initWithWindowNibName:NSStringFromClass([NSWindow2Controller class])];
    
    _nextWindowController.lastWindowController = self;
    
    //让显示的位置居于屏幕的中心
    [[_nextWindowController window] center];
    
    //显示需要跳转的窗口
    [_nextWindowController.window orderFront:nil];
    
    //关闭当前窗口
    [self.window orderOut:nil];
    
}

-(void)buttonClick:(id)sender
{
    NSLog(@"进来了33333");
    
    NSWindow2Controller *nextWindowController = [[NSWindow2Controller alloc] initWithWindowNibName:NSStringFromClass([NSWindow2Controller class])];
    
    //显示需要跳转的窗口
    [nextWindowController.window orderFront:nil];
    
    //关闭当前窗口
    [self.window orderOut:nil];
}



- (void)stopDisappear
{
    NSLog(@"我进来了44444");
}

@end
