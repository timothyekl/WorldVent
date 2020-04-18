//
//  Expect.h
//  TinderboxSixTests
//
//  Created by Mark Bernstein on 10/11/2017.
//  Copyright © 2017 Eastgate Systems Inc. All rights reserved.
//

#pragma once
#import <UIKit/UIKit.h>

#include <string>
using namespace std;


@class XCTestCase;
@class TbxExpectation;      // TODO rename
class xExpectNumber;
class xExpectDate;
class xExpectNode;

class xExpect {
public:
    
    xExpect();
    xExpect(BOOL flag, NSString*,NSInteger,XCTestCase* inTest);

    xExpect(BOOL flag,const xExpect* that);
  
    xExpect(const string& s,const string&,NSInteger,XCTestCase* inTest);
    xExpect(const string& s,NSString* ,NSInteger,XCTestCase* inTest);

    xExpect(const string& s,const xExpect*that);
    

    xExpect(const xExpect& that);
    
    virtual ~xExpect();
    BOOL    Finalize() const;
    BOOL    FinalizeNegative() const;

    
    xExpect IsTrue() const;
    xExpect IsFalse() const;
    xExpect IsNotNil() const;
    xExpect Is(const string& flag) const;
    xExpect Is(NSString* flag) const;


    xExpect Is(BOOL flag) const;

    xExpect IsNot(const string& flag) const;
    xExpect IsNot(NSString* flag) const;

    xExpect BeginsWith(const string&) const;
    xExpect BeginsWith(NSString*) const;
    xExpect EndsWith(const string&) const;
    xExpect EndsWith(NSString*) const;
    xExpect Contains(const string&) const;
    xExpect Contains(NSString*) const;

    xExpectNumber Height() const;
    xExpectNumber Width() const;




    xExpect IsEmpty() const;
    xExpect IsNotEmpty() const;
    xExpect HasSize(NSInteger n) const;

    
    string file;
    NSString* nsfile;
    NSInteger line;
    XCTestCase* test;
    mutable NSString* message;
protected:
    TbxExpectation* impl;
    
    
};


class xExpectString :public xExpect {
public:
    
    xExpectString(const string& s,const string&,NSInteger,XCTestCase* inTest);
    xExpectString(NSString* s,const string&,NSInteger,XCTestCase* inTest);
};




class xExpectView :public xExpect {
public:
    
    xExpectView(UIView* s,const string&,NSInteger,XCTestCase* inTest);
    xExpectView(UIView* s,const xExpect* e);

    virtual ~xExpectView(){}
    
    virtual xExpect IsNotNil() const;
    virtual xExpect IsHidden() const;
    virtual xExpect IsNotHidden() const;
    virtual xExpect IsEnabled() const;
    virtual xExpect IsDisabled() const;


protected:
    UIView* view;
};
    

class xExpectNumber :public xExpect
{
public:
    xExpectNumber(CGFloat f,const string&,NSInteger,XCTestCase* inTest);
    xExpectNumber(CGFloat f,NSString*,NSInteger,XCTestCase* inTest);

    xExpectNumber(CGFloat f,const xExpect*e);
    
    xExpectNumber(const xExpectNumber& that);
    virtual operator CGFloat() const;

    

    xExpect Is(CGFloat n) const;
    xExpect IsNot(CGFloat n) const;

    xExpect IsCloseTo(CGFloat n) const;

    xExpect IsLessThan(CGFloat n) const;
    xExpect IsGreaterThan(CGFloat n) const;

    xExpect IsBetween(CGFloat low,CGFloat high) const;
private:
    CGFloat value;
};




class xExpectArray :public xExpect
{
public:
    xExpectArray(NSArray *,const string&,NSInteger,XCTestCase* inTest);
    xExpectArray(NSArray *,NSString*,NSInteger,XCTestCase* inTest);

    xExpectArray(NSArray*,xExpect* that);
    
    xExpect Has(NSString*) const;
    xExpect DoesNotHave(NSString*) const;

    xExpect HasSize(NSInteger n) const;

    
private:
    NSArray* val;
    
};

class xExpectHTML :public xExpect
{
public:
    xExpectHTML(NSString *,const string&,NSInteger,XCTestCase* inTest);
    xExpectHTML(NSString *,NSString*,NSInteger,XCTestCase* inTest);

    xExpectHTML(NSString*,xExpect* that);
    
    xExpect HasLinks(NSInteger n) const;
    xExpect HasLinkTo(NSString* url) const;

    
private:
    NSString* val;
    NSAttributedString *ns;
    
};



#define Expect(expr) XCTAssertTrue(expr.Finalize())
#define ExpectNot(expr) XCTAssertTrue(!expr.FinalizeNegative())
#define ExpectEventually(expr) XCTAssertTrue(expr.FinalizeEventually(self))


#define expect(e) xExpect(e,__FILE__, __LINE__,self)
#define that(e) xExpect(e,__FILE__, __LINE__,self)

#define thatString(e) xExpectString(e,__FILE__, __LINE__,self)

#define thatView(e) xExpectView(e,__FILE__, __LINE__,self)
#define expectNumber(e) xExpectNumber(e,__FILE__, __LINE__,self)
#define thatNumber(e) xExpectNumber(e,__FILE__, __LINE__,self)
#define thatArray(e) xExpectArray(e,__FILE__, __LINE__,self)
#define thatHTML(e) xExpectHTML(e,__FILE__, __LINE__,self)
