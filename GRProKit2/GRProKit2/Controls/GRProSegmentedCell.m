//
//  GRProSegmentedCell.m
//  GRProKit2
//
//  Created by Guilherme Rambo on 15/11/14.
//  Copyright (c) 2014 Guilherme Rambo. All rights reserved.
//

#import "GRProSegmentedCell.h"

#import <GRProKit2/GRProTheme.h>

@implementation GRProSegmentedCell

#define kSegmentHeightOffset -4.0f
#define kSegmentYOffset 1.0f
#define kSegmentedControlBackgroundRadius 4.0f
#define kSegmentHorizontalMargin 9.0f
#define kSegmentBackgroundYOffset -1.0f

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    NSRect insetFrame = cellFrame;
    insetFrame.size.height += kSegmentHeightOffset;
    insetFrame.origin.y += kSegmentYOffset;
    NSRect shadowFrame = insetFrame;
    shadowFrame.origin.y += kSegmentYOffset;
    
    NSBezierPath *shadow = [NSBezierPath bezierPathWithRoundedRect:shadowFrame xRadius:kSegmentedControlBackgroundRadius yRadius:kSegmentedControlBackgroundRadius];
    [[GRProTheme defaultTheme].buttonShadowColor setFill];
    [shadow fill];
    
    NSBezierPath *bezel = [NSBezierPath bezierPathWithRoundedRect:insetFrame xRadius:kSegmentedControlBackgroundRadius yRadius:kSegmentedControlBackgroundRadius];
    [[GRProTheme defaultTheme].buttonBackgroundColorEnabledOff setFill];
    [bezel fill];

    CGFloat dividedWidth = ceil(NSWidth(cellFrame)/self.segmentCount);
    for (int currentSegment = 0; currentSegment < self.segmentCount; currentSegment++) {
        NSRect segmentFrame = NSMakeRect(currentSegment*dividedWidth+kSegmentHorizontalMargin, kSegmentBackgroundYOffset, dividedWidth, NSHeight(cellFrame));
        
        if (currentSegment == self.selectedSegment) {
            [[NSGraphicsContext currentContext] saveGraphicsState];
            [bezel addClip];
            [self drawSegmentSelectionForSegment:currentSegment withSegmentFrame:segmentFrame];
            [[NSGraphicsContext currentContext] restoreGraphicsState];
        }
        
        [self drawSegment:currentSegment inFrame:segmentFrame withView:controlView];
    }
}

- (void)drawSegmentSelectionForSegment:(NSUInteger)segment withSegmentFrame:(NSRect)segmentFrame
{
    NSRect backgroundFrame = segmentFrame;
    backgroundFrame.origin.x -= kSegmentHorizontalMargin;
    
    [[GRProTheme defaultTheme].buttonBackgroundColorEnabledOn setFill];
    NSRectFill(backgroundFrame);
}

@end
