//
//  GRThemeStore.h
//  packtheme
//
//  Created by Guilherme Rambo on 03/11/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

/*
 GRThemeStore - represents a collection of images for a theme
 This is essentially a class for reading ".pack" files created with "packtheme" and using the images
 */

#import <Cocoa/Cocoa.h>
#import "NSData+ZLib.h"
#import "ThemeFile.h"
#import "GRThemePiece.h"

@interface GRThemeStore : NSObject

// returns a shared instance of GRThemeStore reading from "GRProTheme.pack" inside this framework's resources folder
+ (GRThemeStore *)proThemeStore;

// initializes the ThemeStore using the data from a given file
- (id)initWithCompressedPackageData:(NSData *)data;

// replacement for NSImage's "imageNamed" method
// works exactly the same, but searches for the image inside the ThemeStore
// if the device has a retina display, this method will try to use the 2x version of the image
// and fall back to the default if a 2x is not found in the theme file
- (NSImage *)imageNamed:(NSString *)name;

// an array of GRThemePiece objects, used to find the current theme's images
@property (nonatomic, copy) NSArray *themePieces;

@end
