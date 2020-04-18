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
 

@end
