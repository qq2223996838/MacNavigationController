//
//  AppVCsWindowController.h
//  MacNavigation
//
//  Created by mooer on 2018/8/30.
//  Copyright © 2018年 mooer. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SetUpWindowController.h"
#import "NSWindow1Controller.h"

@interface AppVCsWindowController : SetUpWindowController

@property (strong) IBOutlet NSView *generalPreferenceView;

@property (strong) IBOutlet NSView *colorsPreferenceView;

@property (strong) IBOutlet NSView *playbackPreferenceView;

@property (strong) IBOutlet NSView *updatesPreferenceView;

@property (strong) IBOutlet NSView *advancedPreferenceView;

@property (nonatomic, strong) NSWindow1Controller *nextWindowController;

@end
