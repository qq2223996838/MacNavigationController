//
//  NSWindow3Controller.m
//  MacNavigationController
//
//  Created by mooer on 2018/8/30.
//  Copyright © 2018年 mooer. All rights reserved.
//

#import "NSWindow3Controller.h"
#import "AppDelegate.h"

@interface NSWindow3Controller ()

@end

@implementation NSWindow3Controller

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    self.window.backgroundColor = [NSColor blueColor];
    
}

- (IBAction)view3:(id)sender {
    
    AppDelegate *appDelegate = (AppDelegate *)[[NSApplication sharedApplication] delegate];
    
    [self.window close];
    
    [appDelegate.mainWindowController.window makeKeyAndOrderFront:nil];
    
}



@end
