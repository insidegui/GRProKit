//
//  GRProTheme.m
//  GRProKit2
//
//  Created by Guilherme Rambo on 15/11/14.
//  Copyright (c) 2014 Guilherme Rambo. All rights reserved.
//

#import "GRProTheme.h"
#import "GRProThemeReflection.h"

#import "CUICatalog.h"

@implementation GRProTheme
{
    CUICatalog *_assetCatalog;
}

+ (instancetype)defaultTheme
{
    static GRProTheme *_defaultInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSData *defaultThemeData = [NSData dataWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"DefaultTheme" ofType:@"protheme"]];
        if (!defaultThemeData) @throw [NSException exceptionWithName:@"Default Theme Not Found" reason:@"Unable to load DefaultTheme.protheme" userInfo:nil];
        
        _defaultInstance = [NSKeyedUnarchiver unarchiveObjectWithData:defaultThemeData];
    });
    
    return _defaultInstance;
}

- (NSImage *)imageNamed:(NSString *)name
{
    if (!_assetCatalog) [self initalizeAssetCatalog];
    
    CUINamedImage *cuiImage = [_assetCatalog imageWithName:name scaleFactor:[NSScreen mainScreen].backingScaleFactor];
    
    return [[NSImage alloc] initWithCGImage:cuiImage.image size:cuiImage.size];
}

- (void)initalizeAssetCatalog
{
    if (_assetCatalog) return;
    
    NSError *catalogError;
    _assetCatalog = [[CUICatalog alloc] initWithName:@"Assets" fromBundle:[NSBundle bundleForClass:[self class]] error:&catalogError];
    
    if (catalogError) {
        @throw [NSException exceptionWithName:@"Asset Catalog Error" reason:catalogError.userInfo[@"localizedDescription"] userInfo:nil];
    }
}

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    for (NSDictionary *property in [GRProThemeReflection proThemeProperties]) {
        [aCoder encodeObject:[self valueForKey:property[@"name"]] forKey:property[@"name"]];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    for (NSDictionary *property in [GRProThemeReflection proThemeProperties]) {
        [self setValue:[aDecoder decodeObjectForKey:property[@"name"]] forKey:property[@"name"]];
    }
    
    return self;
}

@end
