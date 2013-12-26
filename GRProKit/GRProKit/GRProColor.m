//
//  GRProColor.m
//  GRProKit
//
//  Created by Guilherme Rambo on 26/12/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import "GRProColor.h"

@implementation GRProColor

@end

@implementation NSColor (GRProKitOverrides)

+ (CGColorRef)_focusRingCGColor
{
    CGColorRef color = [[NSColor colorWithCalibratedRed:0.113725 green:0.376471 blue:0.74902 alpha:0.501961] CGColor];
    return CGColorRetain(color);
}

@end