//
//  GRProWindow.m
//  GRProKit
//
//  Created by Guilherme Rambo on 31/10/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import "GRProWindow.h"
#import "GRProLabel.h"

#import <objc/runtime.h>

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

// window footer gradient - key window
#define kProWindowBottomGradientTopActive [NSColor colorWithCalibratedWhite:0.341 alpha:1.000]
#define kProWindowBottomGradientBottomActive [NSColor colorWithCalibratedWhite:0.257 alpha:1.000]
// window footer gradient - not key window
#define kProWindowBottomGradientTop [NSColor colorWithCalibratedWhite:0.260 alpha:1.000]
#define kProWindowBottomGradientBottom [NSColor colorWithCalibratedWhite:0.219 alpha:1.000]
// window footer highlight and shadowlet colors
#define kProWindowBottomHighlightColor [NSColor colorWithCalibratedWhite:0.427 alpha:1.000]
#define kProWindowBottomShadowletColor [NSColor colorWithCalibratedWhite:0.225 alpha:1.000]

// window title color - key window
#define kProWindowTitleTextColorActive [NSColor blackColor]
// window title color - not key window
#define kProWindowTitleTextColor [NSColor colorWithCalibratedWhite:0.141 alpha:1.000]

float toolbarHeightForWindow(NSWindow *window);

@implementation GRProWindow
{
    GRProThemeWidget *_closeButton;
    GRProThemeWidget *_zoomButton;
    GRProThemeWidget *_miniaturizeButton;
    
    GRProLabel *_titleLabel;
}

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
    
    if(!self) return nil;
    
    // hide standard traffic light buttons
    [[self standardWindowButton:NSWindowCloseButton] setHidden:YES];
    [[self standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
    [[self standardWindowButton:NSWindowZoomButton] setHidden:YES];

    [self layoutTitleLabel];
    
    [self layoutTrafficLights];
    
    // listen to notifications when the window changes it's key status
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didBecomeKey:) name:NSWindowDidBecomeKeyNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didResignKey:) name:NSWindowDidResignKeyNotification object:self];
    
    return self;
}

// traffic light margin from the top of the window
#define kTrafficlightMargin 2.0
// traffic light distance from the window left
#define kTrafficlightDistanceFromWindow 3.0
// size of the traffic light image (width and height are assumed to be equal)
#define kTrafficLightSize 18.0

- (void)layoutTrafficLights
{
    // calculate correct traffic light Y position
    CGFloat buttonY = NSHeight(self.frame)-kTrafficLightSize-kTrafficlightMargin;
    
    // setup close button
    NSRect closeButtonRect = NSMakeRect(kTrafficlightDistanceFromWindow, buttonY, kTrafficLightSize, kTrafficLightSize);
    _closeButton = [[GRProThemeWidget alloc] initWithFrame:closeButtonRect];
    [_closeButton setType:GRProThemeWidgetTypeClose];
    [_closeButton setAutoresizingMask:NSViewMinYMargin|NSViewMaxXMargin];
    [_closeButton setTarget:_closeButton];
    [_closeButton setAction:@selector(performAction:)];
    [_closeButton setEnabled:(self.styleMask & NSClosableWindowMask)];
    [[self.contentView superview] addSubview:_closeButton];
    
    // setup miniaturize button
    NSRect miniaturizeButtonRect = NSMakeRect(closeButtonRect.origin.x+kTrafficLightSize, buttonY, kTrafficLightSize, kTrafficLightSize);
    _miniaturizeButton = [[GRProThemeWidget alloc] initWithFrame:miniaturizeButtonRect];
    [_miniaturizeButton setType:GRProThemeWidgetTypeMiniaturize];
    [_miniaturizeButton setAutoresizingMask:NSViewMinYMargin|NSViewMaxXMargin];
    [_miniaturizeButton setTarget:_miniaturizeButton];
    [_miniaturizeButton setAction:@selector(performAction:)];
    [_miniaturizeButton setEnabled:(self.styleMask & NSMiniaturizableWindowMask)];
    [[self.contentView superview] addSubview:_miniaturizeButton];

    // setup zoom button
    NSRect zoomButtonRect = NSMakeRect(miniaturizeButtonRect.origin.x+kTrafficLightSize, buttonY, kTrafficLightSize, kTrafficLightSize);
    _zoomButton = [[GRProThemeWidget alloc] initWithFrame:zoomButtonRect];
    [_zoomButton setType:GRProThemeWidgetTypeZoom];
    [_zoomButton setAutoresizingMask:NSViewMinYMargin|NSViewMaxXMargin];
    [_zoomButton setTarget:_zoomButton];
    [_zoomButton setAction:@selector(performAction:)];
    [_zoomButton setEnabled:(self.styleMask & NSResizableWindowMask)];
    [[self.contentView superview] addSubview:_zoomButton];
    
    if (self.hideTrafficLights) [self doHideTrafficLights];
}

- (void)doHideTrafficLights {
    [_closeButton setHidden:YES];
    [_miniaturizeButton setHidden:YES];
    [_zoomButton setHidden:YES];
}
- (void)doShowTrafficLights
{
    [_closeButton setHidden:NO];
    [_miniaturizeButton setHidden:NO];
    [_zoomButton setHidden:NO];
}
- (void)setHideTrafficLights:(BOOL)hideTrafficLights
{
    _hideTrafficLights = hideTrafficLights;
    if (_hideTrafficLights) {
        [self doHideTrafficLights];
    } else {
        [self doShowTrafficLights];
    }
}

// setup window's title label
- (void)layoutTitleLabel
{
    // calculate correct title frame and initialize the label
    _titleLabel = [[GRProLabel alloc] initWithFrame:NSMakeRect(0, NSHeight(self.frame)-23, NSWidth(self.frame), 22)];
    
    // if for some reason our title is not available, we don't want to crash :)
    NSString *title = (self.title) ? self.title : @"";
    [_titleLabel setStringValue:title];
    
    [_titleLabel setAlignment:NSCenterTextAlignment];
    [_titleLabel setAutoresizingMask:NSViewWidthSizable|NSViewMinYMargin];
    
    [[self.contentView superview] addSubview:_titleLabel];
}

- (void)setTitle:(NSString *)aString
{
    [super setTitle:aString];
    
    // we need to update our custom title label when the window's  title changes
    [_titleLabel setStringValue:aString];
}

- (void)didBecomeKey:(NSNotification *)notification
{
    // here we update our label's text color when the window becomes active
    [_titleLabel setTextColor:kProWindowTitleTextColorActive];
}

- (void)didResignKey:(NSNotification *)notification
{
    // here we update our label's text color when the window becomes inactive
    [_titleLabel setTextColor:kProWindowTitleTextColor];
}

@end

// window widget's notification names
#define kGRProThemeWidgetGroupActiveNotification @"GRProThemeWidgetGroupActiveNotification"
#define kGRProThemeWidgetGroupInactiveNotification @"GRProThemeWidgetGroupInactiveNotification"

/*
 I decided to use notifications to keep the three buttons in sync, I've found this to be the easiest way (at least that I know of)
 */

@implementation GRProThemeWidget
{
    NSTrackingArea *_trackingArea;
    BOOL _active;
}

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    
    if (!self) return nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeWidgetGroupActive:) name:kGRProThemeWidgetGroupActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeWidgetGroupInactive:) name:kGRProThemeWidgetGroupInactiveNotification object:nil];
    
    return self;
}

- (void)performAction:(id)sender
{
    switch (self.type) {
        case GRProThemeWidgetTypeClose:
            [self.window close];
            break;
        case GRProThemeWidgetTypeMiniaturize:
            [self.window miniaturize:self];
            break;
        default:
            [self.window zoom:self];
            break;
    }
    _active = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kGRProThemeWidgetGroupInactiveNotification object:self];
}

// this is called when the mouse exits any of the window wigets
- (void)themeWidgetGroupInactive:(NSNotification *)notification
{
    // we ignore the notification if we are the sender or if the notification is not from a widget in the same window
    if ([notification.object isEqualTo:self] || ![[notification.object window] isEqual:self.window]) return;
    
    // update the button to be in it's inactive state
    _active = NO;
    [self setNeedsDisplay];
}

// this is called when the mouse enters any of the window wigets
- (void)themeWidgetGroupActive:(NSNotification *)notification
{
    // we ignore the notification if we are the sender or if the notification is not from a widget in the same window
    if ([notification.object isEqualTo:self] || ![[notification.object window] isEqual:self.window]) return;
    
    // update the button to be in it's active state
    _active = YES;
    [self setNeedsDisplay];
}

// here we setup a tracking area to track when the mouse enters or exits the button, the tracking area is active even if our window is not the key window and our app is inactive
- (void)updateTrackingAreas
{
    if (_trackingArea) [self removeTrackingArea:_trackingArea];
    
    _trackingArea = [[NSTrackingArea alloc] initWithRect:self.frame options:NSTrackingActiveAlways|NSTrackingInVisibleRect|NSTrackingMouseEnteredAndExited owner:self userInfo:nil];
    [self addTrackingArea:_trackingArea];
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    // tell our friends we should all be active :)
    [[NSNotificationCenter defaultCenter] postNotificationName:kGRProThemeWidgetGroupActiveNotification object:self];
    
    // update ourselves to be active
    _active = YES;
    [self setNeedsDisplay];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    // tell our friends we should all be inactive :)
    [[NSNotificationCenter defaultCenter] postNotificationName:kGRProThemeWidgetGroupInactiveNotification object:self];
    
    // update ourselves to be inactive
    _active = NO;
    [self setNeedsDisplay];
}

- (void)setType:(GRProThemeWidgetType)type
{
    _type = type;
    
    // if our type changes we need to update our look
    [self setNeedsDisplay];
}

// here's where the magic happens
- (void)drawRect:(NSRect)dirtyRect
{
    NSString *imageBasename;
    
    // we start by determining what the start of the name should be, according to our type
    switch (self.type) {
        case GRProThemeWidgetTypeClose:
            imageBasename = @"close";
            break;
        case GRProThemeWidgetTypeMiniaturize:
            imageBasename = @"miniaturize";
            break;
        default:
            imageBasename = @"zoom";
            break;
    }
    
    NSString *imageName = imageBasename;
    
    NSString *imageSuffix = @"";
    
    if ([self.cell isHighlighted]) {
        // if we are pressed, we need to add a "highlighted" suffix to the image's name
        imageSuffix = @"highlighted";
    } else if (_active) {
        // if we are active (mouse over), we need to add an "active" suffix to the image's name
        imageSuffix = @"active";
    }
    
    // if we should have a suffix, we append It to our original basename, with an underscore
    if(![imageSuffix isEqualToString:@""]) imageName = [imageBasename stringByAppendingFormat:@"_%@", imageSuffix];
    
    // if the our window is not the key window and we are not active, we draw the boring greyed out widget image
    if ((![self.window isKeyWindow] && !_active) || !self.isEnabled) imageName = @"widget_nokey";
    
    // get the correct image from the theme
    NSImage *image = [[GRThemeStore proThemeStore] imageNamed:imageName];
    
    // draw the image in the correct frame
    [image drawInRect:NSMakeRect(0, 0, NSWidth(self.frame), NSHeight(self.frame)) fromRect:NSMakeRect(0, 0, 36, 36) operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
}

@end

// define the methods we are going to override
@interface NSView (Swizzles)
- (void)drawRectOriginal:(NSRect)rect;
- (BOOL)_mouseInGroup:(NSButton*)widget;
- (void)updateTrackingAreas;
@end

@implementation GRProThemeFrame

// this is called when the class is loaded by the objective-c runtime, so it's a good place to do some method swizzling :D
+ (void)load
{
    // get the original NSThemeFrame class (this is the class that's responsible for drawing the window frame)
    Class grayFrameClass = NSClassFromString(@"NSThemeFrame");
    
    // the following code will change the original NSThemeFrame's drawRect: method's name to drawRectOriginal:
    // and put our custom drawRect: method in it's place
    
    Method m0 = class_getInstanceMethod([self class], @selector(drawRect:));

    class_addMethod(grayFrameClass, @selector(drawRectOriginal:), method_getImplementation(m0), method_getTypeEncoding(m0));

    Method m1 = class_getInstanceMethod(grayFrameClass, @selector(drawRect:));
    Method m2 = class_getInstanceMethod(grayFrameClass, @selector(drawRectOriginal:));

    method_exchangeImplementations(m1, m2);
}

// NSThemeFrame's drawRect, here we draw our custom window goodness
- (void)drawRect:(NSRect)rect {
    // draw the original look
    [self drawRectOriginal:rect];
    
    // if this theme frame is not for a GRProWindow, we don't do any custom drawing and keep the system default
    if (![[self window] isKindOfClass:[GRProWindow class]] && ![[self window] isKindOfClass:[NSPanel class]]) return;
    
    // clear the canvas
    [[NSColor clearColor] setFill];
    NSRectFill(rect);
    
    // create a clipping path, with the basic window shape
    NSWindow* window = [self window];
    NSRect windowRect = [window frame];
    windowRect.origin = NSMakePoint(0, 0);
    NSBezierPath *roundedRect = [NSBezierPath bezierPathWithRoundedRect:windowRect xRadius:3 yRadius:3];
    [roundedRect addClip];
    [[NSBezierPath bezierPathWithRect:rect] addClip];
    
    CGFloat toolbarHeight = toolbarHeightForWindow(self.window);
    CGFloat titlebarHeight = toolbarHeight+kProWindowTitlebarHeight;
    
    // paint the background color
    [kProWindowBackgroundColor setFill];
    NSRectFill(rect);
    
    // we don't draw anything else if this window is inside a sheet
    if([self.window isSheet]) return;
    
    // draw the title gradient according to the window's current status
    NSGradient *titleGrad;
    if ([self.window isKeyWindow]) {
        // key window
        titleGrad = [[NSGradient alloc] initWithStartingColor:kProWindowTitleGradientTopActive endingColor:kProWindowTitleGradientBottomActive];
    } else {
        // not key window
        titleGrad = [[NSGradient alloc] initWithStartingColor:kProWindowTitleGradientTop endingColor:kProWindowTitleGradientBottom];
    }
    // draw gradient
    [titleGrad drawInRect:NSMakeRect(0, NSHeight(self.frame)-titlebarHeight, NSWidth(self.frame), titlebarHeight) angle:-90];
    
    // draw gradient separator
    NSRect separatorRect = NSMakeRect(0, NSHeight(self.frame)-titlebarHeight-1, NSWidth(self.frame), 1);
    [kProWindowTitleSeparatorColor setFill];
    NSRectFill(separatorRect);
    
    // draw titlebar highlight
    NSRect highlightRect = NSMakeRect(0, NSHeight(self.frame)-1, NSWidth(self.frame), 1);
    if ([self.window isKeyWindow]) {
        [kProWindowTitleBarHighlightColorActive setFill];
    } else {
        [kProWindowTitleBarHighlightColor setFill];
    }
    NSRectFill(highlightRect);
    
    // the following code will draw the window's footer, if needed
    CGFloat windowContentBorderHeight = [self.window contentBorderThicknessForEdge:NSMinYEdge];
    if (windowContentBorderHeight == 0) return;
    
    // footer gradient
    NSGradient *bottomGrad;
    if ([self.window isKeyWindow]) {
        // key window
        bottomGrad = [[NSGradient alloc] initWithStartingColor:kProWindowBottomGradientTopActive endingColor:kProWindowBottomGradientBottomActive];
    } else {
        // not key window
        bottomGrad = [[NSGradient alloc] initWithStartingColor:kProWindowBottomGradientTop endingColor:kProWindowBottomGradientBottom];
    }
    
    // define a path for the footer
    NSBezierPath *bottomPath = [NSBezierPath bezierPathWithRect:NSMakeRect(0, 0, NSWidth(self.frame), windowContentBorderHeight+1)];
    [bottomGrad drawInBezierPath:bottomPath angle:-90];
    
    // draw the separator between the window's content and footer
    NSRect bottomSeparatorRect = NSMakeRect(0, windowContentBorderHeight-1, NSWidth(self.frame), 1);
    [kProWindowTitleSeparatorColor setFill];
    NSRectFill(bottomSeparatorRect);

    // draw footer highlight
    NSRect bottomHighlightRect = NSMakeRect(0, windowContentBorderHeight-2, NSWidth(self.frame), 1);
    [kProWindowBottomHighlightColor setFill];
    NSRectFill(bottomHighlightRect);
    
    // draw footer shadowlet
    NSRect bottomShadowLetRect = NSMakeRect(0, 0, NSWidth(self.frame), 1);
    [kProWindowBottomShadowletColor setFill];
    NSRectFill(bottomShadowLetRect);
    
    // re-fill the content area to avoid drawing glitches
    NSRect fillerRect = NSMakeRect(0, windowContentBorderHeight, NSWidth(self.frame), NSHeight(self.frame)-kProWindowTitlebarHeight-windowContentBorderHeight-1);
    [kProWindowBackgroundColor setFill];
    NSRectFill(fillerRect);
}

@end

// utility function

float toolbarHeightForWindow(NSWindow *window)
{
    NSToolbar *toolbar;
    
    float toolbarHeight = 0.0;
    
    NSRect windowFrame;

    toolbar = [window toolbar];

    if(toolbar && [toolbar isVisible]) {
        windowFrame = [NSWindow contentRectForFrameRect:[window frame] styleMask:[window styleMask]];
        toolbarHeight = NSHeight(windowFrame) - NSHeight([[window contentView] frame]);
    }

    return toolbarHeight;
}