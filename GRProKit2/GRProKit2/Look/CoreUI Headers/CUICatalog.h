//
//  CUICatalog.h
//  GRProKit2
//
//  Created by Guilherme Rambo on 15/11/14.
//  Copyright (c) 2014 Guilherme Rambo. All rights reserved.
//

@import Cocoa;

#import "CUINamedImage.h"

@interface CUICatalog : NSObject

+ (id)defaultUICatalogForBundle:(NSBundle *)bundle;
+ (id)systemUICatalog;
+ (id)defaultUICatalog;

- (id)initWithName:(NSString *)carFileName fromBundle:(id)arg2 error:(NSError **)outError;
- (id)initWithName:(NSString *)carFileName fromBundle:(id)arg2;

- (CUINamedImage *)imageWithName:(NSString *)name scaleFactor:(double)factor deviceIdiom:(NSInteger)idiom deviceSubtype:(NSUInteger)subtype;
- (CUINamedImage *)imageWithName:(NSString *)name scaleFactor:(double)factor deviceIdiom:(NSInteger)idiom;
- (CUINamedImage *)imageWithName:(NSString *)name scaleFactor:(double)factor;

- (id)_themeStore;

@end
