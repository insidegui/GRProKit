//
//  ThemeFile.h
//  packtheme
//
//  Created by Guilherme Rambo on 03/11/13.
//  Copyright (c) 2013 Guilherme Rambo. All rights reserved.
//

#ifndef packtheme_ThemeFile_h
#define packtheme_ThemeFile_h

/*
 Theme file format definition:
 
 The theme file starts with a master header containing a signature 'TPKG',
 followed by the version number (currently 1),
 entries_offset is the offset for the archived data containing an array of dictionaries with information about each image
 start_offset is the offset for the data of the first image file inside the package
 
 The file is compressed/decompressed using zlib
 */

typedef struct __attribute__((__packed__)) master_header {
    char signature[4];
    char version;
    unsigned long entries_offset;
    unsigned long start_offset;
    char reserved[16];
} master_header_t;

#endif
