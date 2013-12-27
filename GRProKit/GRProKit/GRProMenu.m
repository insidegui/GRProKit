//
//  GRProMenu.m
//  GRProKit
//
//  Created by Guilherme Rambo on 25/12/13.
//  Based on NSMenu+Dark by Seth Willits - https://github.com/swillits/NSMenu-Dark
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import "GRProMenu.h"
#import "GRProFont.h"
#import <objc/runtime.h>

#import <Carbon/Carbon.h>

// This method is not public in 64-bit, but still exists within
// the Carbon framework so we just declare it exists and link to Carbon.
#if __LP64__
extern void SetMenuItemProperty(MenuRef         menu,
								MenuItemIndex   item,
								OSType          propertyCreator,
								OSType          propertyTag,
								ByteCount       propertySize,
								const void *    propertyData);
extern void HIMenuSetFont(MenuRef menu, MenuItemIndex item, CTFontRef font);
#endif

// Menus have a private implementation object, which is "always" a
// NSCarbonMenuImpl instance.
@interface NSMenu (Private)
- (id)_menuImpl;
@end


// NSCarbonMenuImpl is a class, but since it's not public, using
// a protocol to get at the method we want works easily.
@protocol NSCarbonMenuImplProtocol <NSObject>
- (MenuRef)_principalMenuRef;
@end


// Private method which sets the Dark property
@interface NSMenu (DarkPrivate)
- (void)makeDark;
@end


// Helper class used to set darkness after the Carbon MenuRef has been created.
// (The MenuRef doesn't exist until tracking starts.)
@interface NSMenuDarkMaker : NSObject {
	NSMenu * mMenu;
}
- (id)initWithMenu:(NSMenu *)menu;
@end

#pragma mark -
@implementation NSMenu (Dark)
static int MAKE_DARK_KEY;

- (void)setDark:(BOOL)isDark;
{
	if (isDark) {
		NSMenuDarkMaker * maker = [[NSMenuDarkMaker alloc] initWithMenu:self];
		objc_setAssociatedObject(self, &MAKE_DARK_KEY, maker, OBJC_ASSOCIATION_RETAIN);
	} else {
		objc_setAssociatedObject(self, &MAKE_DARK_KEY, nil, OBJC_ASSOCIATION_RETAIN);
	}
}


- (BOOL)isDark;
{
	return (objc_getAssociatedObject(self, &MAKE_DARK_KEY) != nil);
}


- (void)makeDark;
{
	// Make it dark
	id impl = [self _menuImpl];
	if ([impl respondsToSelector:@selector(_principalMenuRef)]) {
		MenuRef m = [impl _principalMenuRef];
		if (m) {
			char on = 1;
			SetMenuItemProperty(m, 0, 'dock', 'dark', 1, &on);

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
            HIMenuSetFont(m, 0, font);
		}
	}
	
	// Make all submenus dark too
	for (NSMenuItem * item in self.itemArray) {
		[item.submenu makeDark];
	}
}

@end

#pragma mark -
@implementation NSMenuDarkMaker

- (id)initWithMenu:(NSMenu *)menu;
{
	if (!(self = [super init])) return nil;
	mMenu = menu;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginTracking:) name:NSMenuDidBeginTrackingNotification object:mMenu];
	return self;
}


- (void)beginTracking:(NSNotification *)note;
{
	[mMenu makeDark];
}

@end

@implementation GRProMenu

+ (void)installGRProMenuImpl:(NSMenu *)menu
{
    
}

- (id)init
{
    self = [super init];
    if(!self) return nil;
    
    self.isDark = YES;
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(!self) return nil;
    
    self.isDark = YES;
    
    return self;
}

@end

/*

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
*/