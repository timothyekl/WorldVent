//
//  HTMLFile.m
//  WorldVentTests
//
//  Created by mark bernstein on 4/20/20.
//

// encapsulates a reference to an HTML page, abstracting out details of reference
// and access

#import <UIKit/UIKit.h>


#import "HTMLFile.h"

@interface HTMLFile()
@property(nonatomic,copy) NSString* path;
@end

@implementation HTMLFile

- (instancetype)initFor: (NSString*) inPath
{
    self = [super init];
    if (self) {
        _path=inPath;
    }
    return self;
}

- (NSString*) filePath
{
    NSString *base=[[NSBundle mainBundle] resourcePath];
    NSString *path=[base stringByAppendingString: @"/doc"];
    path=[path stringByAppendingString: self.path];
    return path;
}

- (BOOL) exists
{
    BOOL found=[[NSFileManager defaultManager]fileExistsAtPath: self.filePath];
    return found;
}

- (NSString*) html
{
    NSData *data=[[NSFileManager defaultManager] contentsAtPath:self.filePath];
    NSString *result=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return result;
}

- (NSString*) extractHref: (NSString*) inTag
{
    __block NSString* dest=nil;
    NSRegularExpression *tagger=[NSRegularExpression regularExpressionWithPattern:@"href=\"(.*?)\"" options:NSRegularExpressionCaseInsensitive|NSRegularExpressionUseUnicodeWordBoundaries error:nil];
    [tagger enumerateMatchesInString:inTag options:0 range:NSMakeRange(0,inTag.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result.numberOfRanges!=2) return;
        dest=[inTag substringWithRange:[ result rangeAtIndex: 1]];
    }];
    return dest;
}

- (NSArray*) stylesheets
{
    // <link rel="stylesheet" href="./css/screen.css" title="WorldVent CSS" type="text/css" media="screen">
    __block NSMutableArray *styles=[NSMutableArray arrayWithCapacity: 10];
    
    NSRegularExpression *tagger=[NSRegularExpression regularExpressionWithPattern:@"<link rel=\"stylesheet\".*>" options:NSRegularExpressionCaseInsensitive|NSRegularExpressionUseUnicodeWordBoundaries error:nil];
    [tagger enumerateMatchesInString:self.html options:0 range:NSMakeRange(0,self.html.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSString *tag=[self.html substringWithRange: result.range];
        NSString *path=[self extractHref: tag];
        [styles addObject: path];
    }];
    
    
    return styles;
}

- (NSArray*) links
{
    NSData *data = [self.html dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString*ns=[[NSAttributedString alloc]initWithData:data options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];

    NSMutableSet *result=[NSMutableSet setWithCapacity:10];
    [ns enumerateAttribute:NSLinkAttributeName inRange:NSMakeRange(0,ns.length)  options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
           if (value) {
               NSURL* url=value;
               [result addObject:url.path];
           }
       }];
    return [result allObjects];
  
}
 

@end
