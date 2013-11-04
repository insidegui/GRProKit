//
//  NSData+ZLib.h
//  packtheme
//
//  Created by Guilherme Rambo on 03/11/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (ZLib)

- (NSData *)zlibDeflate;
- (NSData *)zlibInflate;

@end
