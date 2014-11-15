//
//  Document.m
//  GRProKit2 Theme Builder
//
//  Created by Guilherme Rambo on 15/11/14.
//  Copyright (c) 2014 Guilherme Rambo. All rights reserved.
//

#import "Document.h"

#import <GRProKit2/GRProKit2.h>

#import "GRColoredTableCellView.h"

@interface Document () <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, copy) NSArray *properties;
@property (nonatomic, strong) GRProTheme *workingCopy;

@property (weak) IBOutlet NSTableView *tableView;

@end

@implementation Document

- (instancetype)init {
    if (!(self = [super init])) return nil;

    return self;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
    
    self.properties = [GRProThemeReflection proThemeProperties];
    
    if (!self.workingCopy) self.workingCopy = [[GRProTheme alloc] init];
}

+ (BOOL)autosavesInPlace {
    return YES;
}

- (NSString *)windowNibName {
    return @"Document";
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    return [NSKeyedArchiver archivedDataWithRootObject:self.workingCopy];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    self.workingCopy = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return YES;
}

- (void)setProperties:(NSArray *)properties
{
    _properties = properties;
    
    [self.tableView reloadData];
}

#pragma mark Table View

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.properties.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    GRColoredTableCellView *cellView = [tableView makeViewWithIdentifier:@"cell" owner:tableView];
    
    NSDictionary *property = self.properties[row];
    
    cellView.textField.stringValue = property[@"name"];
    if ([property[@"type"] isEqualToString:@"NSColor"]) {
        NSColor *color = [self.workingCopy valueForKey:property[@"name"]];
        if (color) cellView.colorWell.color = color;
    }
    
    [cellView.colorWell setTarget:self];
    [cellView.colorWell setAction:@selector(colorWellAction:)];
    
    return cellView;
}

- (IBAction)colorWellAction:(id)sender {
    NSDictionary *property = self.properties[[self.tableView rowForView:sender]];
    [self.workingCopy setValue:[sender color] forKey:property[@"name"]];
}

@end
