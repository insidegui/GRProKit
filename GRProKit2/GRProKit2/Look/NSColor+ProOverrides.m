//
//  GRProTheme.m
//  GRProKit2
//
//  Created by Guilherme Rambo on 15/11/14.
//  Copyright (c) 2014 Guilherme Rambo. All rights reserved.
//

#import "GRProTheme.h"

@implementation NSColor (ProOverrides)

+ (NSColor *)labelColor
{
    return [GRProTheme defaultTheme].labelColor;
}

+ (NSColor *)controlTextColor
{
    return [GRProTheme defaultTheme].labelColor;
}

+ (NSColor *)controlBackgroundColor
{
    return [GRProTheme defaultTheme].textFieldBackgroundColor;
}

+ (NSColor *)windowBackgroundColor
{
    return [GRProTheme defaultTheme].windowBackgroundColor;
}

+ (CGColorRef)_focusRingCGColor
{
    CGColorRef color = [[NSColor colorWithCalibratedRed:0.113725 green:0.376471 blue:0.74902 alpha:0.501961] CGColor];
    return CGColorRetain(color);
}

+ (NSColor *)alternateSelectedControlColor
{
    return [GRProTheme defaultTheme].alternateSelectedControlColor;
}

+ (NSColor *)headerColor
{
    return [GRProTheme defaultTheme].headerColor;
}

+ (NSColor *)headerTextColor
{
    return [GRProTheme defaultTheme].headerTextColor;
}

+ (NSColor *)gridColor
{
    return [GRProTheme defaultTheme].gridColor;
}

@end
