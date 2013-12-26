//
//  GRProWindow.h
//  GRProKit
//
//  Created by Guilherme Rambo on 31/10/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

/*
 GRProWindow - a NSWindow subclass that draws a window with the "pro" look
 */

#import <Cocoa/Cocoa.h>

// window widget types
typedef enum {
    GRProThemeWidgetTypeClose = 1,
    GRProThemeWidgetTypeMiniaturize = 2,
    GRProThemeWidgetTypeZoom = 3
} GRProThemeWidgetType;

@interface GRProWindow : NSWindow <NSWindowDelegate>

// property to define whether or not we should display the traffic light widgets
@property (nonatomic, assign) BOOL hideTrafficLights;

@end

// window widget: close, miniaturize and zoom buttons
@interface GRProThemeWidget : NSButton

@property (nonatomic, assign) GRProThemeWidgetType type;

@end

// this is a private interface we're using
@interface NSThemeFrame : NSView
- (void)_drawTitleStringInClip:(NSRect)rect;
- (NSAttributedString *)_currentTitleTextFieldAttributedString;
- (NSButton *)autosaveButton;
- (NSTextField *)_autosaveButtonSeparatorField;
@end

// window theme frame: container class we use to swizzle some drawing methods to draw a custom window frame
@interface GRProThemeFrame : NSThemeFrame

@end