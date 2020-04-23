//
//  HTMLTests.m
//  WorldVentTests
//
//  Created by mark bernstein on 4/20/20.
//  Copyright © 2020 Tim Ekl. All rights reserved.
//
#import "HTMLFile.h"
#import "Expect.h"
#import "TbxString.h"
#import <XCTest/XCTest.h>

@interface HTMLTests : XCTestCase

@end

@implementation HTMLTests

- (void)setUp {
}

- (void)tearDown {
}



- (void) testHTMLHasLinks
{
    NSString* ns=@"<a href=\"a.html\">foo</a> bar <a href=\"b.html\">buzz</a>";
    Expect(thatHTML(ns).HasLinks(2));
    
    Expect(thatHTML(ns).HasLinkTo(@"/a.html"));
}


- (void) testThatIndexExists
{
    HTMLFile *index=[[HTMLFile alloc]initFor:@"/index.html" ];
    Expect(that([index exists]));
}

- (void) testThatIndexHasHTML
{
    HTMLFile *index=[[HTMLFile alloc]initFor:@"/index.html" ];
    NSString *html=[index html];
    Expect(thatString([TbxString for: html]).Contains("<html"));
}


- (void) testThatIndexHasStyleSheet
{
    HTMLFile *index=[[HTMLFile alloc]initFor:@"/index.html" ];
    NSArray *sheets=[index stylesheets];
    Expect(thatArray(sheets).IsNotEmpty());
    Expect(thatArray(sheets).Has(@"./css/screen.css"));

}

- (void) testThatIndexLinksExist
{
    HTMLFile *index=[[HTMLFile alloc]initFor:@"/index.html" ];
    NSArray *links=[index links];
    Expect(thatArray(links).IsNotEmpty());
    for (NSString *path in links) {
        HTMLFile *f=[[HTMLFile alloc]initFor: path];
        Expect(that([f exists]));
    }
}


@end
