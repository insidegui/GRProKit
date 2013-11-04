//
//  GRProSlider.m
//  GRProKit
//
//  Created by Guilherme Rambo on 03/11/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import "GRProSlider.h"

@implementation GRProSlider

@end

@implementation GRProSliderCell

- (void)drawBarInside:(NSRect)aRect flipped:(BOOL)flipped
{
    NSRect endRect = NSMakeRect(aRect.origin.x+2, aRect.origin.y, NSWidth(aRect)-4, NSHeight(aRect));
    NSImage *startCap = [[GRThemeStore proThemeStore] imageNamed:@"slider_startCap"];
    NSImage *centerFill = [[GRThemeStore proThemeStore] imageNamed:@"slider_centerFill"];
    NSImage *endCap = [[GRThemeStore proThemeStore] imageNamed:@"slider_endCap"];
    
    CGFloat fraction = 1.0;
    if (![self isEnabled]) fraction = 0.5;
    
    NSDrawThreePartImage(endRect, startCap, centerFill, endCap, NO, NSCompositeSourceOver, fraction, YES);
}

- (void)drawKnob:(NSRect)knobRect
{
    NSImage *knobImage = [[GRThemeStore proThemeStore] imageNamed:@"slider_knob"];
    if (self.isHighlighted) {
        knobImage = [[GRThemeStore proThemeStore] imageNamed:@"slider_knob_highlighted"];
    }
    
    CGFloat fraction = 1.0;
    if (![self isEnabled]) fraction = 0.5;
    
    [knobImage drawInRect:knobRect fromRect:NSMakeRect(0, 0, knobImage.size.width, knobImage.size.height) operation:NSCompositeSourceOver fraction:fraction respectFlipped:YES hints:nil];
}

@end