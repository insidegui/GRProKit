//
//  GRProColor.m
//  GRProKit
//
//  Created by Guilherme Rambo on 26/12/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import "GRProColor.h"

@implementation GRProColor

+ (void)drawNoiseTextureInRect:(NSRect)rect
{
    [[NSGraphicsContext currentContext] saveGraphicsState];
    
    [NSGraphicsContext saveGraphicsState];
    NSBezierPath *noiseFillPath = [NSBezierPath bezierPathWithRect:rect];
    [noiseFillPath addClip];
    [[NSColor colorWithPatternImage:[[GRThemeStore proThemeStore] imageNamed:@"noise"]] setFill];
    [noiseFillPath fill];
    [NSGraphicsContext restoreGraphicsState];
    
    [[NSGraphicsContext currentContext] restoreGraphicsState];
}

+ (void)drawBackgroundHighlightInRect:(NSRect)rect
{
    [[NSGraphicsContext currentContext] saveGraphicsState];
    
    NSGradient *backgroundLightGradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithCalibratedWhite:1.0 alpha:0.08] endingColor:[NSColor colorWithCalibratedWhite:1.0 alpha:0.0]];
    
    NSPoint centerPoint = NSMakePoint(NSMidX(rect), NSMidY(rect));
    CGFloat radius = MAX(NSHeight(rect), NSWidth(rect))/2;
    [backgroundLightGradient drawFromCenter:centerPoint radius:0 toCenter:centerPoint radius:radius options:NSGradientDrawsAfterEndingLocation|NSGradientDrawsBeforeStartingLocation];
    
    [self drawNoiseTextureInRect:rect];
    
    [[NSGraphicsContext currentContext] restoreGraphicsState];
}

@end

@implementation NSColor (GRProKitOverrides)

+ (CGColorRef)_focusRingCGColor
{
    CGColorRef color = [[NSColor colorWithCalibratedRed:0.113725 green:0.376471 blue:0.74902 alpha:0.501961] CGColor];
    return CGColorRetain(color);
}

@end