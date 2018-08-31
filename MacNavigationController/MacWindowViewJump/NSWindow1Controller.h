//
//  NSWindow1Controller.h
//  MacNavigationController
//
//  Created by mooer on 2018/8/30.
//  Copyright © 2018年 mooer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSWindow2Controller.h"

@interface NSWindow1Controller : NSWindowController

@property (nonatomic, strong) NSWindow2Controller *nextWindowController;

@end
