//
//  GRProColor.h
//  GRProKit
//
//  Created by Guilherme Rambo on 26/12/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GRProColor : NSColor

+ (void)drawNoiseTextureInRect:(NSRect)rect;
+ (void)drawBackgroundHighlightInRect:(NSRect)rect;

@end

// we use this category to override _focusRingCGColor, changing the default focus ring's color
@interface NSColor (GRProKitOverrides)

@end