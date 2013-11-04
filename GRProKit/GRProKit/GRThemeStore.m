//
//  GRThemeStore.m
//  packtheme
//
//  Created by Guilherme Rambo on 03/11/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#import "GRThemeStore.h"

@implementation GRThemeStore
{
    NSData __strong *_compressedData;
    NSData __strong *_data;
    NSData __strong *_plistData;
    NSArray __strong *_entries;
    master_header_t *_themeHeader;
}

+ (GRThemeStore *)proThemeStore
{
    static GRThemeStore *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // get a pointer to the framework's bundle
        NSBundle *bundle = [NSBundle bundleForClass:[GRThemeStore class]];
        // read the theme file inside the framework's resources
        NSData *themeFile = [NSData dataWithContentsOfFile:[bundle pathForResource:@"GRProTheme" ofType:@"pack"]];
        
        _sharedInstance = [[GRThemeStore alloc] initWithCompressedPackageData:themeFile];
    });
    
    return _sharedInstance;
}

- (id)initWithCompressedPackageData:(NSData *)data
{
    self = [super init];
    
    if (!self) return nil;
    
    _compressedData = data;
    
    [self parseData];
    
    return self;
}

// parses a theme file and retrieves It's images, storing them in GRThemePiece objects inside our themePieces array
- (void)parseData
{
    // decompress file
    _data = [_compressedData zlibInflate];
    
    if (!_data) {
        NSLog(@"ThemeStore: failed to decompress theme file!");
        return;
    }
    
    // retrieve header and check
    _themeHeader = (master_header_t *)[[_data subdataWithRange:NSMakeRange(0, sizeof(master_header_t))] bytes];
    if (![self headerSanityCheck]) {
        NSLog(@"ThemeStore: Header sanity check failed!");
        return;
    }
    
    // retrieve the archived data
    _plistData = [_data subdataWithRange:NSMakeRange(_themeHeader->entries_offset, _themeHeader->start_offset-sizeof(master_header_t))];
    if (!_plistData) {
        NSLog(@"ThemeStore: Failed to read plist data!");
        return;
    }
    
    // unarchive the data, which is an NSArray of NSDictionary objects containing basic image information
    _entries = [NSKeyedUnarchiver unarchiveObjectWithData:_plistData];
    if (!_entries) {
        NSLog(@"ThemeStore: Failed to unarchive plist data!");
        return;
    }
    
    NSMutableArray *pieces = [[NSMutableArray alloc] init];
    for (NSDictionary *entry in _entries) {
        // get this image's offset
        unsigned long offset = [entry[@"offset"] unsignedLongValue];
        // get this image's data length
        unsigned long length = [entry[@"length"] unsignedLongValue];
        // read this image's data
        NSData *file = [_data subdataWithRange:NSMakeRange(_themeHeader->start_offset+offset, length)];
        // initialize a NSImage with the data read from the theme
        NSImage *image = [[NSImage alloc] initWithData:file];
        
        // create a theme piece with this information
        GRThemePiece *piece = [GRThemePiece themePieceWithFilename:entry[@"filename"] image:image];
        
        // add do the pieces array
        [pieces addObject:piece];
    }
    
    // save pieces in our array
    self.themePieces = [[NSArray alloc] initWithArray:pieces];
}

- (NSImage *)imageNamed:(NSString *)name
{
    BOOL isRetina = NO;
    // detect retina display
    if ([[NSScreen mainScreen] backingScaleFactor] > 1) isRetina = YES;
    
    GRThemePiece *piece;
    
    // try to get a @2x version of the image if we are on retina
    if (isRetina) piece = [[self.themePieces filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", [name stringByAppendingString:@"@2x"]]] lastObject];
    
    // fallback to default image if @2x is not found, or if we are not on retina
    if (!piece) piece = [[self.themePieces filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name = %@", name]] lastObject];
    
    return [piece image];
}

// performs a basic sanity check to see if the theme file is valid
- (BOOL)headerSanityCheck
{
    if (_themeHeader->signature[3] != 'G' || !_themeHeader->entries_offset || !_themeHeader->start_offset) {
        return NO;
    } else {
        return YES;
    }
}

@end
