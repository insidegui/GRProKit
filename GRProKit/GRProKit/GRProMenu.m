//
//  GRProMenu.m
//  GRProKit
//
//  Created by Guilherme Rambo on 25/12/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import "GRProMenu.h"
#import "GRProFont.h"

#import <Carbon/Carbon.h>

@interface NSCarbonMenuImpl : NSObject
- (MenuRef)_createMenuRef;
@end

@interface GRCarbonMenuImpl : NSCarbonMenuImpl
@end

@implementation GRProMenu

// install custom menu appearance
+ (void)installGRProMenuImpl:(NSMenu *)menu
{
    // this is deprecated, I know :(
    [menu setMenuRepresentation:[[GRCarbonMenuImpl alloc] init]];
}

@end

extern OSErr HIMenuSetFont(MenuRef menu, UInt32 itemIndex, CTFontRef font);

@implementation GRCarbonMenuImpl

- (MenuRef)_createMenuRef
{
    // grab a menu ref
    MenuRef _ref = [super _createMenuRef];

    CFStringRef fontName = CFStringCreateWithCString(kCFAllocatorDefault, kGRProKitFontName, kCFStringEncodingASCII);
    
    // get a font ref with our preferred default font
    CTFontRef font = CTFontCreateWithName(fontName, [GRProFont menuFontSize], NULL);
    
    // if the font doesn't match our preffered font's appearance (i.e. It's not found), use the fallback
    if (![GRProFont CTFontIsDefaultProFont:font]) {
        NSLog(@"GRProKit: %s not found, using fallback font %s", kGRProKitFontName, kGRProKitFallbackFontName);
        fontName = CFStringCreateWithCString(kCFAllocatorDefault, kGRProKitFallbackFontName, kCFStringEncodingASCII);
        font = CTFontCreateWithName(fontName, [GRProFont menuFontSize], NULL);
    }
    
    // set the menu's font
    HIMenuSetFont(_ref, 0, font);
    
    return _ref;
}

@end