//
//  GRProToolbar.m
//  GRProKit
//
//  Created by Guilherme Rambo on 03/11/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import "GRProToolbar.h"
#import "GRProWindow.h"
#import "GRProLabel.h"
#import "GRProFont.h"

@implementation GRProToolbar

@end

@interface NSToolbarItemViewer : NSView
@end

@interface NSToolbarItemViewer (GRProKitOverrides)

@end

// we use a category to override NSToolbarItemViewer,
// this is the view responsible for drawing the toolbar item,
// we need to change the look of selected items
@implementation NSToolbarItemViewer (GRProKitOverrides)

- (void)drawSelectionIndicatorInRect:(NSRect)rect
{
    // background gradient
    NSColor *bgGrad0 = [NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:0.3];
    NSColor *bgGrad1 = [NSColor colorWithCalibratedRed:0 green:0 blue:0 alpha:0];
    NSGradient *selectionIndicatorGrad = [[NSGradient alloc] initWithColorsAndLocations:bgGrad1, 0.0, bgGrad0, 0.53, bgGrad1, 1.0, nil];
    
    // draw background gradient
    NSBezierPath *rectanglePath = [NSBezierPath bezierPathWithRect:rect];
    [selectionIndicatorGrad drawInBezierPath:rectanglePath angle:-90];
    
    // draw left and right borders
    NSRect leftBorderRect = NSMakeRect(0, 0, 1.0, NSHeight(rect));
    [selectionIndicatorGrad drawInRect:leftBorderRect angle:-90];
    
    NSRect rightBorderRect = NSMakeRect(NSWidth(rect)-1.0, 0, 1.0, NSHeight(rect));
    [selectionIndicatorGrad drawInRect:rightBorderRect angle:-90];
}

@end

@interface _NSToolbarItemViewerLabelCellPopUpCell : NSPopUpButtonCell
@end

// we use a category to override the toolbar's label cell drawing
@interface _NSToolbarItemViewerLabelCellPopUpCell (GRProKitOverrides)

@end

@implementation _NSToolbarItemViewerLabelCellPopUpCell (GRProKitOverrides)

// draw toolbar's label title
- (void)drawWithFrame:(NSRect)frame inView:(NSView *)view;
{
    if(![self title]) return;

    NSShadow *titleShadow = [[NSShadow alloc] init];
    titleShadow.shadowBlurRadius = 0;
    titleShadow.shadowOffset = NSMakeSize(0, -1);
    titleShadow.shadowColor = (view.window.isKeyWindow) ? kProWindowTitleShadowColor : kProWindowTitleShadowColorNoKey;
    
    NSColor *titleColor = (view.window.isKeyWindow) ? kProWindowTitleColor : kProWindowTitleColorNoKey;

    NSDictionary *attributes = @{NSFontAttributeName: [GRProFont proToolbarFont], NSForegroundColorAttributeName : titleColor, NSShadowAttributeName : titleShadow};
    
    NSAttributedString *titleString = [[NSAttributedString alloc] initWithString:[self title] attributes:attributes];

    CGFloat centerX = frame.size.width/2-titleString.size.width/2;
    [titleString drawAtPoint:NSMakePoint(centerX, 0)];
}

@end