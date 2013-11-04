//
//  GRThemePiece.h
//  packtheme
//
//  Created by Guilherme Rambo on 03/11/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

/*
 GRThemePiece - Represents an image inside a theme
 name - Image filename without extension
 filename - Original image filename
 image - The image itself
 
 You will probably never use this class directly, It is used internally by GRThemeStore
 */

#import <Cocoa/Cocoa.h>

@interface GRThemePiece : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) NSImage *image;

+ (GRThemePiece *)themePieceWithFilename:(NSString *)aFilename image:(NSImage *)anImage;

@end
