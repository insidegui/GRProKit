//
//  GRProWindow.m
//  GRProKit
//
//  Created by Guilherme Rambo on 31/10/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import "GRProWindow.h"
#import "GRProFont.h"
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


float toolbarHeightForWindow(NSWindow *window);

@implementation GRProWindow
{
    GRProThemeWidget *_closeButton;
    GRProThemeWidget *_zoomButton;
    GRProThemeWidget *_miniaturizeButton;
    
    GRProLabel *_titleLabel;
    
    id _autosaveButton;
}

- (id)initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    self = [super initWithContentRect:contentRect styleMask:aStyle backing:bufferingType defer:flag];
    
    if(!self) return nil;
    
    // hide standard traffic light buttons
    [[self standardWindowButton:NSWindowCloseButton] setHidden:YES];
    [[self standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
    [[self standardWindowButton:NSWindowZoomButton] setHidden:YES];
    
    [self layoutTrafficLights];
    
    return self;
}

- (BOOL)_usesCustomDrawing
{
    return NO;
}

+ (Class)frameViewClassForStyleMask:(NSUInteger)styleMask
{
    return [GRProThemeFrame class];
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

@end

@implementation GRProThemeWidget
{
    BOOL _hover;
}

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    
    if (!self) return nil;
    
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
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    // update ourselves to be active
    _hover = YES;
    [self setNeedsDisplay];
}

- (void)mouseExited:(NSEvent *)theEvent
{
    // update ourselves to be inactive
    _hover = NO;
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
    } else if (_hover) {
        // if we are active (mouse over), we need to add an "active" suffix to the image's name
        imageSuffix = @"active";
    }
    
    // if we should have a suffix, we append It to our original basename, with an underscore
    if(![imageSuffix isEqualToString:@""]) imageName = [imageBasename stringByAppendingFormat:@"_%@", imageSuffix];
    
    // if the our window is not the key window and we are not active, we draw the boring greyed out widget image
    if ((![self.window isKeyWindow] && !_hover) || !self.isEnabled) imageName = @"widget_nokey";
    
    // get the correct image from the theme
    NSImage *image = [[GRThemeStore proThemeStore] imageNamed:imageName];
    
    // draw the image in the correct frame
    [image drawInRect:NSMakeRect(0, 0, NSWidth(self.frame), NSHeight(self.frame)) fromRect:NSMakeRect(0, 0, 36, 36) operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
}

@end

@implementation GRProThemeFrame

// NSThemeFrame's drawRect, here we draw our custom window goodness
- (void)drawRect:(NSRect)rect {
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
    
    if (!(self.window.styleMask & NSTexturedBackgroundWindowMask)) {
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
    }
    
    // draw window's title
    [super _drawTitleStringInClip:self.frame];
    
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

- (NSTextFieldCell *)_customTitleCell
{
    NSTextFieldCell *cell = [[NSTextFieldCell alloc] initTextCell:self.window.title];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSLeftTextAlignment;
    NSShadow *titleShadow = [[NSShadow alloc] init];
    titleShadow.shadowBlurRadius = 0;
    titleShadow.shadowOffset = NSMakeSize(0, -1);
    titleShadow.shadowColor = (self.window.isKeyWindow) ? kProWindowTitleShadowColor : kProWindowTitleShadowColorNoKey;
    
    NSColor *titleColor = (self.window.isKeyWindow) ? kProWindowTitleColor : kProWindowTitleColorNoKey;
    
    NSDictionary *attributes = @{NSFontAttributeName: [GRProFont proLabelFont], NSParagraphStyleAttributeName : style, NSForegroundColorAttributeName : titleColor, NSShadowAttributeName : titleShadow};
    cell.attributedStringValue = [[NSAttributedString alloc] initWithString:self.window.title attributes:attributes];
    
    // also update our "edited" label's attributes
    if ([[self autosaveButton] title]) [[self autosaveButton] setAttributedTitle:[[NSAttributedString alloc] initWithString:[[self autosaveButton] title] attributes:attributes]];
    
    // update the "--" label
    [[self _autosaveButtonSeparatorField] setFont:[GRProFont proLabelFont]];
    [[self _autosaveButtonSeparatorField] setTextColor:titleColor];
    [[self _autosaveButtonSeparatorField] setShadow:titleShadow];
    
    return cell;
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