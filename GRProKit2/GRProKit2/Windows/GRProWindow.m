//
//  GRProWindow.m
//  GRProKit2
//
//  Created by Guilherme Rambo on 15/11/14.
//  Copyright (c) 2014 Guilherme Rambo. All rights reserved.
//

#import "GRProWindow.h"
#import <GRProKit2/GRProTheme.h>

#import "NSWindow-Private.h"
#import "NSTitlebarView.h"
#import "NSThemeFrame.h"
#import "GRProThemeFrame.h"

@implementation GRProWindow

+ (Class)frameViewClassForStyleMask:(NSUInteger)aStyle
{
    return [GRProThemeFrame class];
}

- (BOOL)_usesCustomDrawing
{
    return NO;
}

@end
