//
//  AppDelegate.m
//  MacNavigationController
//
//  Created by mooer on 2018/8/30.
//  Copyright © 2018年 mooer. All rights reserved.
//

#import "AppDelegate.h"
#import "AppVCsWindowController.h"

@interface AppDelegate ()



@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    _mainWindowController = [AppVCsWindowController sharedPrefsWindowController];
    _mainWindowController.toolbarDisplayMode = 1;
    [_mainWindowController showWindow:nil];
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
