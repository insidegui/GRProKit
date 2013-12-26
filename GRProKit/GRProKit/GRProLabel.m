//
//  GRProLabel.m
//  GRProKit
//
//  Created by Guilherme Rambo on 02/11/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import "GRProLabel.h"
#import "GRProFont.h"

@implementation GRProLabel

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (!self) return nil;
    
    [self updateLabelLook];

    return self;
}

- (void)awakeFromNib
{
    [self updateLabelLook];
}

- (void)updateLabelLook
{
    [self setShadow:[GRProLabel proFontShadow]];
    
    [self setBordered:NO];
    [self setDrawsBackground:NO];
    [self setEditable:NO];
    
    [self setFont:[GRProFont proLabelFont]];
}

+ (NSShadow *)proFontShadow
{
    NSShadow *proShadow = [[NSShadow alloc] init];
    proShadow.shadowBlurRadius = 0;
    proShadow.shadowColor = [NSColor colorWithCalibratedWhite:1.0 alpha:0.4];
    proShadow.shadowOffset = NSMakeSize(0, 1);
    
    return proShadow;
}

@end
