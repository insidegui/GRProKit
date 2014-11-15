//
//  GRProTitlebarView.m
//  GRProKit2
//
//  Created by Guilherme Rambo on 15/11/14.
//  Copyright (c) 2014 Guilherme Rambo. All rights reserved.
//

#import "GRProTitlebarView.h"
#import "GRProThemeFrame.h"
#import <GRProKit2/GRProTheme.h>

@implementation GRProTitlebarView
{
    GRProThemeFrame *_associatedThemeFrame;
    NSTrackingArea *_leftButtonGroupTrackingArea;
    NSDictionary *_leftButtonGroupUserInfo;
}

- (instancetype)initWithFrame:(NSRect)frameRect
{
    if (!(self = [super initWithFrame:frameRect])) return nil;
    
    [self setDrawsSeparator:YES];
    [self setTransparent:NO];
    
    return self;
}

- (void)_setAssociatedThemeFrame:(GRProThemeFrame *)themeFrame
{
    _associatedThemeFrame = themeFrame;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[GRProTheme defaultTheme].titlebarGradientColor1
                                                         endingColor:[GRProTheme defaultTheme].titlebarGradientColor2];
    [gradient drawInRect:dirtyRect angle:-90];
    
    NSRect separatorRect = NSMakeRect(0, 0, NSWidth(self.frame), 1.0);
    [[GRProTheme defaultTheme].titlebarSeparatorColor setFill];
    NSRectFill(separatorRect);
}

- (void)updateTrackingAreas
{
    if (!_leftButtonGroupUserInfo) {
        _leftButtonGroupUserInfo = @{@"leftButtonGroup": @1};
    }
    
    [self removeTrackingArea:_leftButtonGroupTrackingArea];
    
    _leftButtonGroupTrackingArea = [[NSTrackingArea alloc] initWithRect:[_associatedThemeFrame leftButtonGroupFrameInTitlebarView]
                                                                options:NSTrackingActiveAlways|NSTrackingMouseEnteredAndExited
                                                                  owner:self
                                                               userInfo:_leftButtonGroupUserInfo];
    [self addTrackingArea:_leftButtonGroupTrackingArea];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    if (theEvent.userData == (__bridge void *)(_leftButtonGroupUserInfo)) [_associatedThemeFrame mouseEnteredLeftButtonGroup];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    if (theEvent.userData == (__bridge void *)(_leftButtonGroupUserInfo)) [_associatedThemeFrame mouseExitedLeftButtonGroup];
}

- (void)disableBlurFilter
{
    return;
}

@end
