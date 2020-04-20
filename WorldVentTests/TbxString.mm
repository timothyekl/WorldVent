//
//  TbxString.m
//  TinderboxSix
//
//  Created by Mark Bernstein on 1/28/2016.
//  Copyright © 2016 Eastgate Systems Inc. All rights reserved.
//

#import "TbxString.h"

@implementation TbxString

+ (string) for: ( NSString*) s
{
    if (!s) return "";
    return [s UTF8String];
}


@end
