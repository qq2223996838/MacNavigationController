//
//  SetUpWindowController.m
//  MacNavigation
//
//  Created by mooer on 2018/8/30.
//  Copyright © 2018年 mooer. All rights reserved.
//

#import "SetUpWindowController.h"

@interface SetUpWindowController ()
@property (nonatomic, strong) NSMutableArray *toolbarIdentifiers;
@property (nonatomic, strong) NSMutableDictionary *toolbarViews;
@property (nonatomic, strong) NSMutableDictionary *toolbarItems;
@property (nonatomic, strong) NSViewAnimation *viewAnimation;
@property (nonatomic, strong) NSView *contentSubview;
@end

@implementation SetUpWindowController

#pragma mark -
#pragma mark Class Methods

+ (SetUpWindowController *)sharedPrefsWindowController{
    static SetUpWindowController *_sharedPrefsWindowController = nil;
    if(!_sharedPrefsWindowController){
        _sharedPrefsWindowController = [[self alloc] initWithWindowNibName:[self nibName]];
    }
    return _sharedPrefsWindowController;
}

//子类可以重写这个以使用一个不同名称的nib
+ (NSString *)nibName{
    return @"Preferences";
}

#pragma mark -
#pragma mark Setup & Teardown

- (id)initWithWindow:(NSWindow *)window{
    if((self = [super initWithWindow:nil])){
        //设置一个数组和一些字典来跟踪
        //我们将要显示的视图
        self.toolbarIdentifiers = [[NSMutableArray alloc] init];
        self.toolbarViews = [[NSMutableDictionary alloc] init];
        self.toolbarItems = [[NSMutableDictionary alloc] init];
        
        //设置一个NSViewAnimation动画转换
        self.viewAnimation = [[NSViewAnimation alloc] init];
        [self.viewAnimation setAnimationBlockingMode:NSAnimationNonblocking];
        [self.viewAnimation setAnimationCurve:NSAnimationEaseInOut];
        [self.viewAnimation setDelegate:(id<NSAnimationDelegate>)self];
        
        self.crossFade = YES;
        self.shiftSlowsAnimation = YES;
    }
    return self;
}

- (void)windowDidLoad{
    //创建一个新窗口来显示首选项视图。
    //如果开发人员在这个控制器上附加了一个窗口
    //在Interface Builder中，它被替换为这个
    
    NSWindow *window =
    [[NSWindow alloc] initWithContentRect:NSMakeRect(0,0,1000,1000)
                                styleMask:(NSWindowStyleMaskTitled |
                                           NSWindowStyleMaskClosable |
                                           NSWindowStyleMaskMiniaturizable)
                                  backing:NSBackingStoreBuffered
                                    defer:YES];
    [self setWindow:window];
    self.contentSubview = [[NSView alloc] initWithFrame:[[[self window] contentView] frame]];
    [self.contentSubview setAutoresizingMask:(NSViewMinYMargin | NSViewWidthSizable)];
    [[[self window] contentView] addSubview:self.contentSubview];
    [[self window] setShowsToolbarButton:NO];
}


#pragma mark -
#pragma mark Configuration

- (void)setupToolbar{
    //子类必须重写此方法以将项添加到
    //工具栏通过调用-addView:label:或-addView:label:image:
}

- (void)addToolbarItemForIdentifier:(NSString *)identifier
                              label:(NSString *)label
                              image:(NSImage *)image
                           selector:(SEL)selector {
    [self.toolbarIdentifiers addObject:identifier];
    
    NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:identifier];
    [item setLabel:label];
    [item setImage:image];
    [item setTarget:self];
    [item setAction:selector];
    
    (self.toolbarItems)[identifier] = item;
}

- (void)addFlexibleSpacer {
    [self addToolbarItemForIdentifier:NSToolbarFlexibleSpaceItemIdentifier label:nil image:nil selector:nil];
}

- (void)addView:(NSView *)view label:(NSString *)label imageUrl:(NSString *)imageUrl {
    [self addView:view label:label image:[NSImage imageNamed:imageUrl]];
}

- (void)addView:(NSView *)view label:(NSString *)label image:(NSImage *)image{
    if(view == nil){
        return;
    }
    
    NSString *identifier = [label copy];
    (self.toolbarViews)[identifier] = view;
    [self addToolbarItemForIdentifier:identifier
                                label:label
                                image:image
                             selector:@selector(toggleActivePreferenceView:)];
}

#pragma mark -
#pragma mark Overriding Methods

- (IBAction)showWindow:(id)sender{
    // This forces the resources in the nib to load.
    [self window];
    
    //迫使nib中的资源加载
    [self.toolbarIdentifiers removeAllObjects];
    [self.toolbarViews removeAllObjects];
    [self.toolbarItems removeAllObjects];
    [self setupToolbar];
    
    if(![_toolbarIdentifiers count]){
        return;
    }
    
    if([[self window] toolbar] == nil){
        NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"PreferencesToolbar"];
        [toolbar setAllowsUserCustomization:NO];
        [toolbar setAutosavesConfiguration:NO];
        [toolbar setSizeMode:NSToolbarSizeModeDefault];
        //NSToolbar风格：图标＋文字形式
        if (_toolbarDisplayMode == 2) {
            [toolbar setDisplayMode:NSToolbarDisplayModeLabelOnly];
        }else if (_toolbarDisplayMode == 3){
            [toolbar setDisplayMode:NSToolbarDisplayModeIconOnly];
        }else{
            [toolbar setDisplayMode:NSToolbarDisplayModeIconAndLabel];
        }
        
        [toolbar setDelegate:(id<NSToolbarDelegate>)self];
        [[self window] setToolbar:toolbar];
    }
    
    NSString *firstIdentifier = (self.toolbarIdentifiers)[0];
    [[[self window] toolbar] setSelectedItemIdentifier:firstIdentifier];
    [self displayViewForIdentifier:firstIdentifier animate:NO];
    
    [[self window] center];
    
    [super showWindow:sender];
}


#pragma mark -
#pragma mark Toolbar

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar{
    return self.toolbarIdentifiers;
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar{
    return self.toolbarIdentifiers;
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar{
    return self.toolbarIdentifiers;
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)identifier willBeInsertedIntoToolbar:(BOOL)willBeInserted{
    return (self.toolbarItems)[identifier];
}

- (void)toggleActivePreferenceView:(NSToolbarItem *)toolbarItem{
    [self displayViewForIdentifier:[toolbarItem itemIdentifier] animate:YES];
}

- (void)displayViewForIdentifier:(NSString *)identifier animate:(BOOL)animate{
    //找到我们想要显示的视图
    NSView *newView = (self.toolbarViews)[identifier];
    
    //看看是否有可见的视图。
    NSView *oldView = nil;
    if([[self.contentSubview subviews] count] > 0) {
        //获取窗口中所有视图的列表。通常在这个
        //点只有一个可见视图。但如果最后一个消失了
        //还没做完，我们得先把它处理掉，然后再继续
        NSEnumerator *subviewsEnum = [[self.contentSubview subviews] reverseObjectEnumerator];
        
        //第一个(最后一个添加)是我们的可视视图
        oldView = [subviewsEnum nextObject];
        
        //删除任何其他人
        NSView *reallyOldView = nil;
        while((reallyOldView = [subviewsEnum nextObject]) != nil){
            [reallyOldView removeFromSuperviewWithoutNeedingDisplay];
        }
    }
    
    if(![newView isEqualTo:oldView]){
        NSRect frame = [newView bounds];
        frame.origin.y = NSHeight([self.contentSubview frame]) - NSHeight([newView bounds]);
        [newView setFrame:frame];
        [self.contentSubview addSubview:newView];
        [[self window] setInitialFirstResponder:newView];
        
        if(animate && [self crossFade]){
            [self crossFadeView:oldView withView:newView];
        }else{
            [oldView removeFromSuperviewWithoutNeedingDisplay];
            [newView setHidden:NO];
            [[self window] setFrame:[self frameForView:newView] display:YES animate:animate];
        }
        
        [[self window] setTitle:[(self.toolbarItems)[identifier] label]];
    }
}

- (void)loadViewForIdentifier:(NSString *)identifier animate:(BOOL)animate {
    [[[self window] toolbar] setSelectedItemIdentifier:identifier];
    [self displayViewForIdentifier:identifier animate:animate];
}


#pragma mark -
#pragma mark Cross-Fading Methods

- (void)crossFadeView:(NSView *)oldView withView:(NSView *)newView{
    [self.viewAnimation stopAnimation];
    
    if([self shiftSlowsAnimation] && [[[self window] currentEvent] modifierFlags] & NSEventModifierFlagShift){
        [self.viewAnimation setDuration:1.25];
    }else{
        [self.viewAnimation setDuration:0.25];
    }
    
    NSDictionary *fadeOutDictionary =
    @{NSViewAnimationTargetKey: oldView,
      NSViewAnimationEffectKey: NSViewAnimationFadeOutEffect};
    
    NSDictionary *fadeInDictionary =
    @{NSViewAnimationTargetKey: newView,
      NSViewAnimationEffectKey: NSViewAnimationFadeInEffect};
    
    NSDictionary *resizeDictionary =
    @{NSViewAnimationTargetKey: [self window],
      NSViewAnimationStartFrameKey: [NSValue valueWithRect:[[self window] frame]],
      NSViewAnimationEndFrameKey: [NSValue valueWithRect:[self frameForView:newView]]};
    
    NSArray *animationArray =
    @[fadeOutDictionary,
      fadeInDictionary,
      resizeDictionary];
    
    [self.viewAnimation setViewAnimations:animationArray];
    [self.viewAnimation startAnimation];
}

- (void)animationDidEnd:(NSAnimation *)animation{
    NSView *subview;
    
    //获取窗口中所有视图的列表
    //这里有两个 一个是可见，一个是隐藏。
    NSEnumerator *subviewsEnum = [[self.contentSubview subviews] reverseObjectEnumerator];
    
    //这是可视视图
    [subviewsEnum nextObject];
    
    //删除一切. 应该只有一个，但是如果用户进行了大量的快速点击，我们可能会一个以上移走
    while((subview = [subviewsEnum nextObject]) != nil){
        [subview removeFromSuperviewWithoutNeedingDisplay];
    }
    
    //这是一个防止第一个的变通方法
    //工具栏图标
    [[self window] makeFirstResponder:nil];
}

//计算新视图的窗口大小。
- (NSRect)frameForView:(NSView *)view{
    NSRect windowFrame = [[self window] frame];
    NSRect contentRect = [[self window] contentRectForFrameRect:windowFrame];
    float windowTitleAndToolbarHeight = NSHeight(windowFrame) - NSHeight(contentRect);
    
    windowFrame.size.height = NSHeight([view frame]) + windowTitleAndToolbarHeight;
    windowFrame.size.width = NSWidth([view frame]);
    windowFrame.origin.y = NSMaxY([[self window] frame]) - NSHeight(windowFrame);
    
    return windowFrame;
}

//用cmd+w关闭窗口，以防应用程序没有应用程序菜单
- (void)keyDown:(NSEvent *)theEvent{
    NSString *key = [theEvent charactersIgnoringModifiers];
    if(([theEvent modifierFlags] & NSEventModifierFlagCommand) && [key isEqualToString:@"w"]){
        [self close];
    }else{
        [super keyDown:theEvent];
    }
}


@end
