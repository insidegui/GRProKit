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

// the following constants define the look and layout for the window, have fun messing around with them :)

// the height for the title bar
// changing this will not really work because we are assuming the titlebar will have the standard window titlebar size
#define kProWindowTitlebarHeight 22

// window background color
#define kProWindowBackgroundColor [NSColor colorWithCalibratedWhite:0.151 alpha:1.000]

// titlebar gradient colors - key window
#define kProWindowTitleGradientTopActive [NSColor colorWithCalibratedWhite:0.459 alpha:1.000]
#define kProWindowTitleGradientBottomActive [NSColor colorWithCalibratedWhite:0.330 alpha:1.000]
// titlebar gradient colors - not key window
#define kProWindowTitleGradientTop [NSColor colorWithCalibratedWhite:0.300 alpha:1.000]
#define kProWindowTitleGradientBottom [NSColor colorWithCalibratedWhite:0.215 alpha:1.000]
// titlebar bottom separator color
#define kProWindowTitleSeparatorColor [NSColor blackColor]
// titlebar top highlight color - key window
#define kProWindowTitleBarHighlightColorActive [NSColor colorWithCalibratedWhite:0.647 alpha:1.000]
// titlebar top highlight color - not key window
#define kProWindowTitleBarHighlightColor [NSColor colorWithCalibratedWhite:0.435 alpha:1.000]

#define kProWindowTitleColor [NSColor colorWithCalibratedWhite:0.038 alpha:1.000]
#define kProWindowTitleColorNoKey [NSColor colorWithCalibratedWhite:0.141 alpha:1.000]
#define kProWindowTitleShadowColor [NSColor colorWithCalibratedWhite:0.5 alpha:1.000]
#define kProWindowTitleShadowColorNoKey [NSColor colorWithCalibratedWhite:0.5 alpha:0]

// window footer gradient - key window
#define kProWindowBottomGradientTopActive [NSColor colorWithCalibratedWhite:0.341 alpha:1.000]
#define kProWindowBottomGradientBottomActive [NSColor colorWithCalibratedWhite:0.257 alpha:1.000]
// window footer gradient - not key window
#define kProWindowBottomGradientTop [NSColor colorWithCalibratedWhite:0.260 alpha:1.000]
#define kProWindowBottomGradientBottom [NSColor colorWithCalibratedWhite:0.219 alpha:1.000]
// window footer highlight and shadowlet colors
#define kProWindowBottomHighlightColor [NSColor colorWithCalibratedWhite:0.427 alpha:1.000]
#define kProWindowBottomShadowletColor [NSColor colorWithCalibratedWhite:0.225 alpha:1.000]

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
@property (nonatomic, assign) BOOL hover;

@end

// this is a private interface we're using
@interface NSThemeFrame : NSView
- (void)_drawTitleStringInClip:(NSRect)rect;
- (NSAttributedString *)_currentTitleTextFieldAttributedString;
- (NSButton *)autosaveButton;
- (NSTextField *)_autosaveButtonSeparatorField;
- (NSRect)_titlebarTitleRect;
@end

// window theme frame: container class we use to swizzle some drawing methods to draw a custom window frame
@interface GRProThemeFrame : NSThemeFrame

- (void)resetWidgets;

@end