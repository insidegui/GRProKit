//
//  GRProBox.m
//  GRProKit
//
//  Created by Guilherme Rambo on 02/11/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import "GRProBox.h"
#import "GRProLabel.h"

#define kProBoxBackgroundColor [NSColor colorWithCalibratedWhite:0.121 alpha:1.000]

@implementation GRProBox
{
    GRProLabel *_titleLabel;
}

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    
    if(!self) return nil;
    
    [self setupLabel];
    
    return self;
}

- (void)setupLabel
{
    _titleLabel = [[GRProLabel alloc] initWithFrame:NSMakeRect(8, NSHeight(self.frame)-15, NSWidth(self.frame)*0.8, 15)];
    [_titleLabel setAutoresizingMask:NSViewMinXMargin|NSViewMaxYMargin];
    [_titleLabel setTextColor:[NSColor colorWithCalibratedWhite:0.642 alpha:1.000]];
    NSShadow *titleShadow = [[NSShadow alloc] init];
    titleShadow.shadowBlurRadius = 0.5;
    titleShadow.shadowOffset = NSMakeSize(0, 1);
    titleShadow.shadowColor = [NSColor colorWithCalibratedWhite:0 alpha:0.7];
    [_titleLabel setShadow:titleShadow];
    NSString *title = (self.title)? self.title : @"";
    [_titleLabel setStringValue:title];
    [_titleLabel setAutoresizingMask:NSViewMaxXMargin|NSViewMinYMargin];
    [self addSubview:_titleLabel];
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    
    _titleLabel.stringValue = self.title;
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSBezierPath *shape = [NSBezierPath bezierPathWithRect:self.frame];
    [kProBoxBackgroundColor setFill];
    [shape fill];
    
    NSImage *topImage = [[GRThemeStore proThemeStore] imageNamed:@"box_top"];
    [topImage drawInRect:NSMakeRect(0, NSHeight(self.frame)-21, NSWidth(self.frame), 21.0) fromRect:NSMakeRect(0, 0, 2.0, 21.0) operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
    
    NSImage *bottomImage = [[GRThemeStore proThemeStore] imageNamed:@"box_bottom"];
    [bottomImage drawInRect:NSMakeRect(0, 0, NSWidth(self.frame), 30.0) fromRect:NSMakeRect(0, 0, 2.0, 30.0) operation:NSCompositeSourceOver fraction:1.0 respectFlipped:YES hints:nil];
}

@end
