//
//  AppDelegate.h
//  MacNavigationController
//
//  Created by mooer on 2018/8/30.
//  Copyright © 2018年 mooer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AppVCsWindowController.h"
#import "SetUpWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) SetUpWindowController *mainWindowController;

@end

