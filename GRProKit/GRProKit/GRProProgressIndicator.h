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
#define kProgressBarProGradientColor0 [NSColor colorWithCalibratedRed:0.42f green:0.44f blue:0.47f alpha:1.0f]
#define kProgressBarProGradientColor1 [NSColor colorWithCalibratedRed:0.38f green:0.42f blue:0.45f alpha:1.0f]
#define kProgressBarProGradientColor2 [NSColor colorWithCalibratedRed:0.34f green:0.38f blue:0.43f alpha:1.0f]
#define kProgressBarProGradientColor3 [NSColor colorWithCalibratedRed:0.36f green:0.41f blue:0.45f alpha:1.0f]
#define kProgressBarProGradientColor4 [NSColor colorWithCalibratedRed:0.42f green:0.46f blue:0.47f alpha:1.0f]

// progress bar gradient colors from top to bottom, inactive window
#define kProgressBarInactiveGradientColor0 [NSColor colorWithCalibratedWhite:0.845 alpha:1.000]
#define kProgressBarInactiveGradientColor1 [NSColor colorWithCalibratedWhite:0.737 alpha:1.000]
#define kProgressBarInactiveGradientColor2 [NSColor colorWithCalibratedWhite:0.665 alpha:1.000]
#define kProgressBarInactiveGradientColor3 [NSColor colorWithCalibratedWhite:0.585 alpha:1.000]
#define kProgressBarInactiveGradientColor4 [NSColor colorWithCalibratedRed: 0.53 green: 0.587 blue: 0.662 alpha: 1]

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
