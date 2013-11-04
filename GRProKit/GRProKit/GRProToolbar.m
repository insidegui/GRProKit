//
//  GRProToolbar.m
//  GRProKit
//
//  Created by Guilherme Rambo on 03/11/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import "GRProToolbar.h"
#import <objc/runtime.h>

@implementation GRProToolbar

@end

@implementation GRProToolbarItem

@end

// define the methods we are going to override
@interface NSView (Private)
- (void)drawRectOriginal:(NSRect)rect;
@end

static BOOL _updatedToolbarLabels = NO;

@implementation GRProToolbarView

+ (void)load
{
    // get the original NSToolbarView class (this is the class that's responsible for drawing the toolbar background)
    Class grayFrameClass = NSClassFromString(@"NSToolbarView");
    
    // the following code will change the original NSToolbarView's drawRect: method's name to drawRectOriginal:
    // and put our custom drawRect: method in it's place
    
    Method m0 = class_getInstanceMethod([self class], @selector(drawRect:));
    
    class_addMethod(grayFrameClass, @selector(drawRectOriginal:), method_getImplementation(m0), method_getTypeEncoding(m0));
    
    Method m1 = class_getInstanceMethod(grayFrameClass, @selector(drawRect:));
    Method m2 = class_getInstanceMethod(grayFrameClass, @selector(drawRectOriginal:));
    
    method_exchangeImplementations(m1, m2);
}

- (void)drawRect:(NSRect)dirtyRect
{
    if (_updatedToolbarLabels) return;
    
    _updatedToolbarLabels = YES;
    for (NSView *view in [self.subviews[0] subviews]) {
        for (id itemView in [view subviews]) {
            if ([itemView isKindOfClass:NSClassFromString(@"_NSToolbarItemViewerLabelView")]) {
                [itemView setFont:[NSFont fontWithName:@"Helvetica" size:12.0]];
            }
        }
    }
}

@end