//
//  GRProSearchFieldCell.m
//  GRProKit2
//
//  Created by Guilherme Rambo on 15/11/14.
//  Copyright (c) 2014 Guilherme Rambo. All rights reserved.
//

#import "GRProSearchFieldCell.h"

#import "GRProTheme.h"

@implementation GRProSearchFieldCell
{
    BOOL _proCustomizationInstalled;
}

- (void)installProCustomization
{
    if (_proCustomizationInstalled) return;
    _proCustomizationInstalled = YES;
    
    self.searchButtonCell.image = [[GRProTheme defaultTheme] imageNamed:@"SearchButton"];
    self.cancelButtonCell.image = [[GRProTheme defaultTheme] imageNamed:@"CancelSearchButton"];
    [self setTextColor:[GRProTheme defaultTheme].labelColor];
}

- (instancetype)initTextCell:(NSString *)aString
{
    if (!(self = [super initTextCell:aString])) return nil;
    
    [self installProCustomization];
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self installProCustomization];
}

- (void)_drawBezeledBackgroundWithFrame:(NSRect)bezelFrame inView:(NSView *)view includeFocus:(BOOL)flag
{
    NSBezierPath *bezel = [NSBezierPath bezierPathWithRoundedRect:bezelFrame xRadius:4.0 yRadius:4.0];
    [[GRProTheme defaultTheme].textFieldBackgroundColor setFill];
    [bezel fill];
}

- (NSBackgroundStyle)interiorBackgroundStyle
{
    return NSBackgroundStyleLowered;
}

- (double)_cancelButtonInsetForBounds:(struct CGRect)arg1 userInterfaceLayoutDirection:(long long)arg2
{
    return 0;
}

@end
