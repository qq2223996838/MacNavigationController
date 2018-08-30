//
//  SetUpWindowController.h
//  MacNavigation
//
//  Created by mooer on 2018/8/30.
//  Copyright © 2018年 mooer. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SetUpWindowController : NSWindowController

@property (nonatomic) BOOL crossFade;
@property (nonatomic) BOOL shiftSlowsAnimation;

+ (SetUpWindowController *)sharedPrefsWindowController;
+ (NSString *)nibName;

- (void)setupToolbar;
- (void)addFlexibleSpacer;
- (void)addView:(NSView *)view label:(NSString *)label imageUrl:(NSString *)imageUrl;
- (void)addView:(NSView *)view label:(NSString *)label image:(NSImage *)image;

- (void)toggleActivePreferenceView:(NSToolbarItem *)toolbarItem;
- (void)displayViewForIdentifier:(NSString *)identifier animate:(BOOL)animate;
- (void)crossFadeView:(NSView *)oldView withView:(NSView *)newView;
- (NSRect)frameForView:(NSView *)view;

//为给定的标识符选择view & toolbar项
- (void)loadViewForIdentifier:(NSString *)identifier animate:(BOOL)animate;

@end
