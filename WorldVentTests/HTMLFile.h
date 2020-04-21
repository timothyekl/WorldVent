//
//  HTMLFile.h
//  WorldVentTests
//
//  Created by mark bernstein on 4/20/20.
//  Copyright © 2020 Tim Ekl. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTMLFile : NSObject

@property(nonatomic,copy,readonly) NSString* path;

- (instancetype)initFor: (NSString*) inPath;
- (BOOL) exists;
- (NSArray*) stylesheets;
- (NSString*) html;
- (NSArray*) links;


@end

NS_ASSUME_NONNULL_END
