//
//  GRProButtonCell.m
//  GRProKit2
//
//  Created by Guilherme Rambo on 15/11/14.
//  Copyright (c) 2014 Guilherme Rambo. All rights reserved.
//

#import "GRProButtonCell.h"

#import "GRProTheme.h"

@implementation GRProButtonCell

#define kPushButtonTopOffset -6.0f
#define kPushButtonSideOffset -7.0f
#define kPushButtonBottomOffset -8.0f
#define kPushButtonRadius 4.0f

- (void)drawBezelWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    // TODO: draw other types of buttons
    switch (self.bezelStyle) {
        case NSRoundedBezelStyle:
            [self drawRoundedBezelWithFrame:frame];
            break;
        default:
            [self drawRoundedBezelWithFrame:frame];
            break;
    }
}

- (void)drawRoundedBezelWithFrame:(NSRect)frame
{
    NSRect bezelFrame = frame;
    bezelFrame.size.height += kPushButtonBottomOffset+kPushButtonTopOffset;
    bezelFrame.origin.y -= kPushButtonTopOffset;
    bezelFrame.size.width += kPushButtonSideOffset*2;
    bezelFrame.origin.x += ABS(kPushButtonSideOffset);
    
    NSRect shadowFrame = bezelFrame;
    shadowFrame.origin.y += 1;
    
    NSBezierPath *shadow = [NSBezierPath bezierPathWithRoundedRect:shadowFrame xRadius:kPushButtonRadius yRadius:kPushButtonRadius];
    [[GRProTheme defaultTheme].buttonBackgroundColorEnabledOn setFill];
    [shadow fill];
    
    if (!self.highlighted) {
        NSRect highlightFrame = bezelFrame;
        highlightFrame.origin.y -= 1;
        NSBezierPath *highlight = [NSBezierPath bezierPathWithRoundedRect:highlightFrame xRadius:kPushButtonRadius yRadius:kPushButtonRadius];
        [[GRProTheme defaultTheme].buttonHighlightColor setFill];
        [highlight fill];
    }

    NSBezierPath *bezel = [NSBezierPath bezierPathWithRoundedRect:bezelFrame xRadius:kPushButtonRadius yRadius:kPushButtonRadius];
    
    if (![self.keyEquivalent isEqualToString:@"\r"]) {
        if (self.enabled) {
            if (!self.isHighlighted) {
                [[GRProTheme defaultTheme].buttonBackgroundColorEnabledOff setFill];
            } else {
                [[GRProTheme defaultTheme].buttonBackgroundColorEnabledOn setFill];
            }
        } else {
            if (self.state == 0) {
                [[GRProTheme defaultTheme].buttonBackgroundColorDisabledOff setFill];
            } else {
                [[GRProTheme defaultTheme].buttonBackgroundColorDisabledOn setFill];
            }
        }
        
        [bezel fill];
    } else {
        NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[GRProTheme defaultTheme].defaultButtonBackgroundColor1
                                                             endingColor:[GRProTheme defaultTheme].defaultButtonBackgroundColor2];
        if (self.enabled) {
            [gradient drawInBezierPath:bezel angle:90];
            
            if (self.isHighlighted) {
                [[NSColor colorWithCalibratedWhite:0 alpha:0.2] setFill];
                [bezel fill];
            }
        } else {
            if (self.state == 0) {
                [[GRProTheme defaultTheme].buttonBackgroundColorDisabledOff setFill];
            } else {
                [[GRProTheme defaultTheme].buttonBackgroundColorDisabledOn setFill];
            }
            
            [bezel fill];
        }
    }
}

@end
