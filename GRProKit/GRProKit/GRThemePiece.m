//
//  GRThemePiece.m
//  packtheme
//
//  Created by Guilherme Rambo on 03/11/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import "GRThemePiece.h"

@implementation GRThemePiece

+ (GRThemePiece *)themePieceWithFilename:(NSString *)aFilename image:(NSImage *)anImage
{
    GRThemePiece *instance = [[GRThemePiece alloc] init];
    
    if (!instance) return nil;
    
    instance.filename = aFilename;
    instance.image = anImage;
    
    return instance;
}

- (void)setFilename:(NSString *)filename
{
    _filename = filename;
    
    // populate our "name" automatically, removing the extension from the filename
    NSURL *url = [NSURL URLWithString:_filename];
    self.name = [[url URLByDeletingPathExtension] path];
}

@end
