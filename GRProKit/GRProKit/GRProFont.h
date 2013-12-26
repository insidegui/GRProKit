//
//  GRProFont.h
//  GRProKit
//
//  Created by Guilherme Rambo on 25/12/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define kGRProKitFontName "HelveticaNeue"
#define kGRProKitFallbackFontName "Helvetica"
#define kGRProKitDefaultFontSize 13.0

#define kGRProKitPreferredFontBoundingBox NSMakeRect(-13.314, -6.734039306640625, 33.558, 21.811981201171875)

@interface GRProFont : NSFont

+ (BOOL)CTFontIsDefaultProFont:(CTFontRef)font;
+ (CGFloat)menuFontSize;
+ (NSFont *)proLabelFont;
+ (NSFont *)proControlFont;

@end
