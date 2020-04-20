//
//  ExpectTests.m
//  WorldVentTests
//
//  Created by mark bernstein on 4/18/20.
//  Copyright © 2020 Tim Ekl. All rights reserved.
//

#include <string>       // TODO get rid of this
using namespace std;

#import "Expect.h"
#import <XCTest/XCTest.h>

@interface ExpectTests : XCTestCase

@end

@implementation ExpectTests

- (void)setUp {
}

- (void)tearDown {
}

- (void)testStrings {
    Expect(thatString("foo").IsTrue());
    Expect(thatString("").IsFalse());
    Expect(thatString("foo").Is("foo"));
    Expect(thatString("foo").IsNot("bar"));
    Expect(thatString("foo").BeginsWith("f"));
    Expect(thatString("foo").BeginsWith("g").IsFalse());
    Expect(thatString("foo").EndsWith("o"));
    Expect(thatString("foo").EndsWith("p").IsFalse());
    
    Expect(thatString("hello, she lied").Contains("hello"));
    Expect(thatString("hello, she lied").Contains("she"));
    Expect(thatString("hello, she lied").Contains("lied"));
    Expect(thatString("hello, she lied").Contains("frog").IsFalse());
}

- (void)testNSStrings {
    Expect(thatString(@"foo").IsTrue());
    Expect(thatString(@"").IsFalse());
    Expect(thatString(@"foo").Is(@"foo"));
    Expect(thatString(@"foo").IsNot(@"bar"));
    Expect(thatString(@"foo").BeginsWith(@"f"));
    Expect(thatString(@"foo").BeginsWith(@"g").IsFalse());
    Expect(thatString(@"foo").EndsWith(@"o"));
    Expect(thatString(@"foo").EndsWith(@"p").IsFalse());
    
    Expect(thatString(@"hello, she lied").Contains(@"hello"));
    Expect(thatString(@"hello, she lied").Contains(@"she"));
    Expect(thatString(@"hello, she lied").Contains(@"lied"));
    Expect(thatString(@"hello, she lied").Contains(@ "frog").IsFalse());
}


- (void) testNumbers
{
    Expect(thatNumber(3).Is(3));
    Expect(thatNumber(3).Is(4).IsFalse());
    Expect(thatNumber(3).IsNot(0));
    Expect(thatNumber(3).IsNot(3).IsFalse());
    
    Expect(thatNumber(3).IsGreaterThan(2));
    Expect(thatNumber(3).IsGreaterThan(4).IsFalse());
    Expect(thatNumber(3).IsLessThan(42));
    Expect(thatNumber(3).IsLessThan(2).IsFalse());
}

- (void) testViews
{
    UIControl *view=[[UIControl alloc]init];
    Expect(thatView(view).IsHidden().IsFalse());
    [view setHidden: YES];
    Expect(thatView(view).IsHidden());
    [view setHidden: NO];
    ExpectNot(thatView(view).IsHidden());
    
    [view setEnabled: YES];
    Expect(thatView(view).IsEnabled());
    [view setEnabled: NO];
    ExpectNot(thatView(view).IsEnabled());
    
    Expect(thatView(view).IsNotNil());
}

- (void) testArrays
{
    NSArray *a=@[@"Winken",@"Blinken",@"Nod"];
    Expect(thatArray(a).HasSize(3));
    Expect(thatArray(a).Has(@"Winken"));
    Expect(thatArray(a).DoesNotHave(@"literary merit"));
}

- (void) testHTMLHasLinks
{
    NSString* ns=@"<a href=\"a.html\">foo</a> bar <a href=\"b.html\">buzz</a>";
    Expect(thatHTML(ns).HasLinks(2));
    
    Expect(thatHTML(ns).HasLinkTo(@"/a.html"));
}
 

@end
