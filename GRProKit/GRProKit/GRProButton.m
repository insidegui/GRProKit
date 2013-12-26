//
//  GRProButton.m
//  GRProKit
//
//  Created by Guilherme Rambo on 03/11/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import "GRProButton.h"
#import <QuartzCore/QuartzCore.h>
#import "GRProFont.h"
#import "GRProMenu.h"

@interface GRProButtonOverlayView : NSView
@end

@implementation GRProButton
{
    GRProButtonOverlayView *_overlayView;
}

- (void)setDefault:(BOOL)isDefault
{
    _isDefault = isDefault;
    
    // if the button is the default, we need to setup the overlay view,
    // this view will be animated to creat that flashing button effect
    if (isDefault) {
        // this is required for the animation to work correctly
        self.wantsLayer = YES;
        
        if (!_overlayView) {
            // create the overlay view and add It as a subview
            _overlayView = [[GRProButtonOverlayView alloc] initWithFrame:NSMakeRect(0, 0, NSWidth(self.frame), NSHeight(self.frame))];
            _overlayView.alphaValue = 0;
            [self addSubview:_overlayView];
            
            // start overlay animation
            [self animateOverlay];
        }
    } else {
        if (_overlayView) [_overlayView removeFromSuperview];
    }
}

// animate overlay in
- (void)animateOverlay
{
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:1.5];
    
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        [self animateOverlayReverse];
    }];
    
    _overlayView.animator.alphaValue = 1;
    
    [NSAnimationContext endGrouping];
}
// animate overlay out
- (void)animateOverlayReverse
{
    [NSAnimationContext beginGrouping];
    [[NSAnimationContext currentContext] setDuration:1.5];
    [[NSAnimationContext currentContext] setCompletionHandler:^{
        [self animateOverlay];
    }];
    
    _overlayView.animator.alphaValue = 0;
    
    [NSAnimationContext endGrouping];
}

@end

@implementation GRProButtonCell

// this method is responsible for drawing the title of the button
// we override It so we can change the font's attributes
- (NSRect)drawTitle:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView
{
    NSMutableParagraphStyle *pstyle = [[NSMutableParagraphStyle alloc] init];
    pstyle.alignment = NSCenterTextAlignment;
    
    // text shadow
    NSShadow *shadow = [[NSShadow alloc] init];
    if (self.isHighlighted) {
        // text shadow for button pressed state
        shadow.shadowBlurRadius = 6;
        shadow.shadowColor = [NSColor colorWithCalibratedRed:0.085 green:0.206 blue:0.820 alpha:1.000];
        shadow.shadowOffset = NSMakeSize(0, 0);
    } else {
        // text shadow for normal button state
        shadow.shadowBlurRadius = 1;
        shadow.shadowColor = [NSColor colorWithCalibratedWhite:0 alpha:0.7];
        shadow.shadowOffset = NSMakeSize(0, -1);
    }
    
    // text color
    NSColor *textColor;
    if (self.isHighlighted) {
        // text color for pressed state
        textColor = [NSColor colorWithCalibratedWhite:0.715 alpha:1.000];
    } else {
        // text color for normal state
        textColor = [NSColor colorWithCalibratedWhite:0.415 alpha:1.000];
    }
    
    if (![self isEnabled]) {
        textColor = [NSColor colorWithCalibratedWhite:0.415 alpha:0.500];
    }
    
    // configure font attributes (font name and size, color, paragraph style and shadow)
    NSDictionary *fontAttributes = @{NSFontAttributeName: [GRProFont proLabelFont],
                                     NSForegroundColorAttributeName: textColor,
                                     NSParagraphStyleAttributeName: pstyle,
                                     NSShadowAttributeName: shadow};
    
    // create a new attributed string with our custom attributes and the original text
    NSAttributedString *modifiedTitle = [[NSAttributedString alloc] initWithString:title.string attributes:fontAttributes];
    
    return [super drawTitle:modifiedTitle withFrame:frame inView:controlView];
}

// draws the button's bezel
- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    NSImage *startCap;
    NSImage *centerFill;
    NSImage *endCap;
    
    if (self.isHighlighted) {
        // images for pressed state
        startCap = [[GRThemeStore proThemeStore] imageNamed:@"startCap_highlighted"];
        centerFill = [[GRThemeStore proThemeStore] imageNamed:@"centerFill_highlighted"];
        endCap = [[GRThemeStore proThemeStore] imageNamed:@"endCap_highlighted"];
    } else {
        // images for normal state
        startCap = [[GRThemeStore proThemeStore] imageNamed:@"startCap"];
        centerFill = [[GRThemeStore proThemeStore] imageNamed:@"centerFill"];
        endCap = [[GRThemeStore proThemeStore] imageNamed:@"endCap"];
    }
    
    // draw the images
    NSDrawThreePartImage(frame, startCap, centerFill, endCap, NO, NSCompositeSourceOver, 1.0, YES);
}

- (NSRect)titleRectForBounds:(NSRect)theRect
{
    // we basically make the title occupy the whole button, and center It using paragraph styles (see drawTitle:... above)
    return NSMakeRect(0, 0, NSWidth(theRect), NSHeight(theRect));
}

@end

@implementation GRProCheckboxCell

- (void)drawImage:(NSImage *)image withFrame:(NSRect)frame inView:(NSView *)controlView
{
    NSString *imageBasename = @"checkbox";
    NSString *imageSuffix1 = @"";
    NSString *imageSuffix2 = @"";
    
    if (self.intValue == 0) {
        imageSuffix1 = @"_off";
    } else {
        imageSuffix1 = @"_on";
    }
    
    if (self.isHighlighted) {
        imageSuffix2 = @"_highlighted";
    }
    
    CGFloat fraction = 1.0;
    // if the control is disabled, we draw the image with half the alpha
    if (!self.isEnabled) fraction = 0.5;
    
    NSString *imageName = [NSString stringWithFormat:@"%@%@%@", imageBasename, imageSuffix1, imageSuffix2];
    
    NSImage *theImage = [[GRThemeStore proThemeStore] imageNamed:imageName];
    
    NSRect finalRect = NSMakeRect(frame.origin.x, frame.origin.y-1, NSWidth(frame), NSHeight(frame));
    
    [theImage drawInRect:finalRect fromRect:NSMakeRect(0, 0, theImage.size.width-1, theImage.size.height) operation:NSCompositeSourceOver fraction:fraction respectFlipped:YES hints:nil];
}

- (NSRect)drawTitle:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView
{
    // text color
    NSColor *textColor = [NSColor colorWithCalibratedWhite:0.415 alpha:1.000];
    
    if (![self isEnabled]) textColor = [NSColor colorWithCalibratedWhite:0.415 alpha:0.500];
    
    NSMutableParagraphStyle *pstyle = [[NSMutableParagraphStyle alloc] init];
    pstyle.alignment = NSLeftTextAlignment;
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 1;
    shadow.shadowColor = [NSColor colorWithCalibratedWhite:0 alpha:0.7];
    shadow.shadowOffset = NSMakeSize(0, -1);
    
    // configure font attributes (font name and size, color, paragraph style and shadow)
    NSDictionary *fontAttributes = @{NSFontAttributeName: [GRProFont proLabelFont],
                                     NSForegroundColorAttributeName: textColor,
                                     NSParagraphStyleAttributeName: pstyle,
                                     NSShadowAttributeName: shadow};
    
    // create a new attributed string with our custom attributes and the original text
    NSAttributedString *modifiedTitle = [[NSAttributedString alloc] initWithString:title.string attributes:fontAttributes];
    
    return [super drawTitle:modifiedTitle withFrame:frame inView:controlView];
}

@end

@implementation GRProRadioButtonCell

- (void)drawImage:(NSImage *)image withFrame:(NSRect)frame inView:(NSView *)controlView
{
    NSString *imageBasename = @"radio";
    NSString *imageSuffix1 = @"";
    NSString *imageSuffix2 = @"";
    
    if (self.intValue == 0) {
        imageSuffix1 = @"_off";
    } else {
        imageSuffix1 = @"_on";
    }
    
    if (self.isHighlighted) {
        imageSuffix2 = @"_highlighted";
    }
    
    CGFloat fraction = 1.0;
    // if the control is disabled, we draw the image with half the alpha
    if (!self.isEnabled) fraction = 0.5;
    
    NSString *imageName = [NSString stringWithFormat:@"%@%@%@", imageBasename, imageSuffix1, imageSuffix2];
    
    NSImage *theImage = [[GRThemeStore proThemeStore] imageNamed:imageName];
    
    NSRect finalRect = NSMakeRect(frame.origin.x, frame.origin.y-1, NSWidth(frame), NSHeight(frame));
    
    [theImage drawInRect:finalRect fromRect:NSMakeRect(0, 0, theImage.size.width, theImage.size.height) operation:NSCompositeSourceOver fraction:fraction respectFlipped:YES hints:nil];
    
    // draw focus
    if ([[self.controlView.window firstResponder] isEqual:self.controlView]) {
        NSImage *focusImage = [[GRThemeStore proThemeStore] imageNamed:@"radio_focus"];
        [focusImage drawInRect:finalRect fromRect:NSMakeRect(0, 0, focusImage.size.width, focusImage.size.height) operation:NSCompositePlusLighter fraction:1.0 respectFlipped:YES hints:nil];
    }
}

@end

@implementation GRProPopUpButtonCell

- (NSRect)drawTitle:(NSAttributedString *)title withFrame:(NSRect)frame inView:(NSView *)controlView
{
    NSMutableParagraphStyle *pstyle = [[NSMutableParagraphStyle alloc] init];
    pstyle.alignment = NSLeftTextAlignment;
    
    // text shadow
    NSShadow *shadow = [[NSShadow alloc] init];
    // text shadow for normal button state
    shadow.shadowBlurRadius = 1;
    shadow.shadowColor = [NSColor colorWithCalibratedWhite:0 alpha:0.7];
    shadow.shadowOffset = NSMakeSize(0, -1);
    
    // text color
    NSColor *textColor;
    // text color for normal state
    textColor = [NSColor colorWithCalibratedWhite:0.765 alpha:1.000];
    
    if (![self isEnabled]) {
        textColor = [NSColor colorWithCalibratedWhite:0.415 alpha:0.500];
    }
    
    // configure font attributes (font name and size, color, paragraph style and shadow)
    NSDictionary *fontAttributes = @{NSFontAttributeName: [GRProFont proLabelFont],
                                     NSForegroundColorAttributeName: textColor,
                                     NSParagraphStyleAttributeName: pstyle,
                                     NSShadowAttributeName: shadow};
    
    // create a new attributed string with our custom attributes and the original text
    NSAttributedString *modifiedTitle = [[NSAttributedString alloc] initWithString:title.string attributes:fontAttributes];
    frame.origin.y -= 1;
    return [super drawTitle:modifiedTitle withFrame:frame inView:controlView];
}

- (NSRect)titleRectForBounds:(NSRect)theRect
{
    return NSMakeRect(8, 5, NSWidth(theRect), NSHeight(theRect));
}

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    NSImage *startCap;
    NSImage *centerFill;
    NSImage *endCap;
    
    if (self.isHighlighted) {
        // images for pressed state
        startCap = [[GRThemeStore proThemeStore] imageNamed:@"popup_startCap_highlighted"];
        centerFill = [[GRThemeStore proThemeStore] imageNamed:@"popup_centerFill_highlighted"];
        endCap = [[GRThemeStore proThemeStore] imageNamed:@"popup_endCap_highlighted"];
    } else {
        // images for normal state
        startCap = [[GRThemeStore proThemeStore] imageNamed:@"popup_startCap"];
        centerFill = [[GRThemeStore proThemeStore] imageNamed:@"popup_centerFill"];
        endCap = [[GRThemeStore proThemeStore] imageNamed:@"popup_endCap"];
    }
    
    // draw the images
    NSDrawThreePartImage(frame, startCap, centerFill, endCap, NO, NSCompositeSourceOver, 1.0, YES);
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self) return nil;
    
    [GRProMenu installGRProMenuImpl:self.menu];
    
    return self;
}

@end

// just a blue overlay view to use with GRProButton when It's set to default
@implementation GRProButtonOverlayView

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if(!self) return nil;
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSBezierPath *bezierPath = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(0, 1, NSWidth(self.frame), NSHeight(self.frame)-1) xRadius:4 yRadius:4];
    [bezierPath addClip];
    
    [[NSColor colorWithCalibratedRed:0 green:0 blue:1.0 alpha:0.3] setFill];
    NSRectFill(dirtyRect);
}

@end