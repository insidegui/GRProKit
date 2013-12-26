//
//  GRProFont.h
//  GRProKit
//
//  Created by Guilherme Rambo on 25/12/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// default font for controls, labels, etc
#define kGRProKitFontName "Helvetica"
// fallback font if default font is not available
#define kGRProKitFallbackFontName "LucidaGrande"
// default font size for labels
#define kGRProKitDefaultFontSize 13.0

// this is used to identify the default font's availability when using CoreText
#define kGRProKitPreferredFontBoundingBox NSMakeRect(-13.3095703125, -6.7333984375, 33.55078125, 22.435546875)

// offset for window's titles according to the font being used
#define kGRProKitDefaultFontTitleHeightOffset 0.0
#define kGRProKitFallbackFontTitleHeightOffset 0.0

@interface GRProFont : NSFont

+ (BOOL)CTFontIsDefaultProFont:(CTFontRef)font;
+ (CGFloat)menuFontSize;
+ (NSFont *)proLabelFont;
+ (NSFont *)proControlFont;
+ (NSFont *)proTitleFont;
+ (NSFont *)proToolbarFont;
+ (CGFloat)windowTitleHeightOffsetForFont:(NSFont *)font;

@end
