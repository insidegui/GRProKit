//
//  GRProThemeFrame.m
//  GRProKit2
//
//  Created by Guilherme Rambo on 15/11/14.
//  Copyright (c) 2014 Guilherme Rambo. All rights reserved.
//

#import "GRProThemeFrame.h"
#import "GRProTitlebarView.h"
#import "GRProTheme.h"

@implementation GRProThemeFrame

- (id)_makeTitlebarViewWithFrame:(NSRect)frameRect
{
    return [[GRProTitlebarView alloc] initWithFrame:frameRect];
}

- (NSColor *)_currentTitleColor
{
    return [GRProTheme defaultTheme].titlebarTextColor;
}

- (NSTextField *)_titleTextField
{
    NSTextField *ttf = [super _titleTextField];
    [[ttf cell] setBackgroundStyle:NSBackgroundStyleLowered];
    
    return ttf;
}

@end
