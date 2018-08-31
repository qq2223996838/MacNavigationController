//
//  NSWindow2Controller.m
//  MacNavigationController
//
//  Created by mooer on 2018/8/30.
//  Copyright © 2018年 mooer. All rights reserved.
//

#import "NSWindow1Controller.h"
#import "NSWindow2Controller.h"
#import "NSWindow3Controller.h"

@interface NSWindow2Controller ()

@property (nonatomic, strong) NSWindow3Controller *nextWindowController;

@end

@implementation NSWindow2Controller

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    self.window.backgroundColor = [NSColor yellowColor];
    
}
- (IBAction)Toview1:(id)sender {
    
    if ([_lastWindowController isKindOfClass:[NSWindow1Controller class]])
    {
        NSWindow1Controller *mainWC = (NSWindow1Controller *)_lastWindowController;
        
        [self.window close];
        mainWC.nextWindowController = nil;
        
        [mainWC.window orderFront:nil];
        
    }
}

- (IBAction)view2:(id)sender {
    
    _nextWindowController = [[NSWindow3Controller alloc] initWithWindowNibName:NSStringFromClass([NSWindow3Controller class])];
    
    //让显示的位置居于屏幕的中心
    [[_nextWindowController window] center];
    
    //显示需要跳转的窗口
    [_nextWindowController.window orderFront:nil];
    
    //关闭当前窗口
    [self.window orderOut:nil];
}



@end
