//
//  GRProProgressIndicator.h
//  GRProKit
//
//  Created by Guilherme Rambo on 03/11/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/*
 GRProProgressIndicator - NSProgressIndicator replacement
 Original project with more features: https://github.com/insidegui/GRProgressIndicator
 */

// progress bar gradient colors from top to bottom, graphite
#define kProgressBarProGradientColor0 [NSColor colorWithCalibratedRed:0.261 green:0.415 blue:0.677 alpha:1.000]
#define kProgressBarProGradientColor1 [NSColor colorWithCalibratedRed:0.120 green:0.284 blue:0.597 alpha:1.000]
#define kProgressBarProGradientColor2 [NSColor colorWithCalibratedRed:0.095 green:0.258 blue:0.580 alpha:1.000]
#define kProgressBarProGradientColor3 [NSColor colorWithCalibratedRed:0.119 green:0.325 blue:0.727 alpha:1.000]
#define kProgressBarProGradientColor4 [NSColor colorWithCalibratedRed:0.159 green:0.402 blue:0.839 alpha:1.000]

// progress bar gradient colors from top to bottom, inactive window
#define kProgressBarInactiveGradientColor0 [NSColor colorWithCalibratedRed:0.435 green:0.446 blue:0.467 alpha:1.000]
#define kProgressBarInactiveGradientColor1 [NSColor colorWithCalibratedRed:0.308 green:0.325 blue:0.348 alpha:1.000]
#define kProgressBarInactiveGradientColor2 [NSColor colorWithCalibratedRed:0.297 green:0.314 blue:0.337 alpha:1.000]
#define kProgressBarInactiveGradientColor3 [NSColor colorWithCalibratedRed:0.400 green:0.426 blue:0.459 alpha:1.000]
#define kProgressBarInactiveGradientColor4 [NSColor colorWithCalibratedRed:0.423 green:0.450 blue:0.484 alpha:1.000]

// line after progress bar gradient colors from bottom to top
#define kProgressBarProgressLineGradient0 [NSColor colorWithCalibratedWhite:0.3 alpha:1.0f]
#define kProgressBarProgressLineGradient1 [NSColor colorWithCalibratedWhite:0.2 alpha:1.0f]

@interface GRProProgressIndicator : NSView

@property (nonatomic, assign) double doubleValue;
@property (nonatomic, assign) double minValue;
@property (nonatomic, assign) double maxValue;

@property (nonatomic, assign, getter = isIndeterminate) BOOL indeterminate;

- (void)startAnimation:(id)sender;
- (void)stopAnimation:(id)sender;

@end
