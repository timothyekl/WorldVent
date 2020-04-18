//
//  Expect.mm
//  TinderboxSixTests
//
//  Created by Mark Bernstein on 10/11/2017.
//  Copyright © 2017 Eastgate Systems Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "TbxString.h"
#import "Expect.h"

// TODO replace all strings with NSString

class xExpect;

@class TbxBooleanExpectation;

@interface TbxExpectation: NSObject
@property(nonatomic,assign) xExpect* expectation;

- (instancetype) initWith: ( xExpect*) e;
- (BOOL) finalize;
- (xExpect) isTrue;
- (xExpect) isFalse;

- (xExpect) is: (BOOL) flag;

- (xExpect) isSelected;
- (xExpect) isHidden;
- (xExpect) isEqualTo: (CGFloat) f;
- (xExpect) isEmpty;
- (xExpect) hasSize: (NSInteger) n;
- (xExpectNumber) getDouble: (const string&) attrib ;
- (xExpectNumber) getLong: (const string&) attrib ;


- (xExpect) getString: (const string&) attrib ;
- (xExpect) getBoolean: (const string&) attrib ;
- (xExpect) hasSameParent ;
- (CGFloat) doubleValue;


@end

@implementation TbxExpectation

- (instancetype) initWith: (xExpect*) e
{
    self=[super init];
    if (self) {
        _expectation=e;
    }
    return self;
}


- (void)recordFailure:(NSString *)format, ...;
{
    if(self.expectation->message) return;   // we’ve already go a message
    
    va_list ap;
    va_start(ap, format);
    NSString *d = [[NSString alloc] initWithFormat:format arguments:ap];
    va_end(ap);
    
    self.expectation->message=d;
    
   
}


- (BOOL) finalize {return false;}
- (xExpect) isTrue {return xExpect(false,self.expectation);}
- (xExpect) isFalse {return xExpect(false,self.expectation); }
- (xExpect) is: (BOOL) flag {return xExpect(false,self.expectation); }
- (xExpect) isString: (const string&) flag {return xExpect(false,self.expectation); }
- (xExpect) isNotString: (const string&) flag {return xExpect(false,self.expectation); }
- (xExpect) beginsWith: (const string&) flag {return xExpect(false,self.expectation); }
- (xExpect) endsWith: (const string&) flag {return xExpect(false,self.expectation); }
- (xExpect) contains: (const string&) flag {return xExpect(false,self.expectation); }

- (xExpectNumber) height {return xExpectNumber(0,self.expectation); }
- (xExpectNumber) width {return xExpectNumber(0,self.expectation); }


- (xExpect) isEmpty {return xExpect(false,self.expectation);}
- (xExpect) isNotEmpty {return xExpect(false,self.expectation);}

- (xExpect) hasSize: (NSInteger) n {return xExpect(false,self.expectation);}
- (xExpect) isNamed: (const string&) n {return xExpect(false,self.expectation);}
- (xExpect) hasAPrototype {return xExpect(false,self.expectation);}
- (xExpect) hasYear: (NSInteger) n {return xExpect(false,self.expectation);}
- (xExpect) hasMonth: (NSInteger) n {return xExpect(false,self.expectation);}
- (xExpect) hasDay: (NSInteger) n {return xExpect(false,self.expectation);}
- (xExpect) isVisible {return xExpect(false,self.expectation);}
- (xExpect) isNotVisible {return xExpect(false,self.expectation);}
- (xExpect) exists {return xExpect(false,self.expectation);}
- (xExpect) isInstalled {return xExpect(false,self.expectation);}
- (xExpect) isExpanded {return xExpect(false,self.expectation);}
- (xExpect) isNotExpanded {return xExpect(false,self.expectation);}



- (xExpect) currentItemIs: (const string&) n {return xExpect(false,self.expectation);}
- (xExpectNumber) indexOf: (const string&) attrib
    {return xExpectNumber(-1,self.expectation); }

- (xExpect) isSelected {return xExpect(false,self.expectation); }
- (xExpect) isHidden {return xExpect(false,self.expectation); }

- (xExpect) isEqualTo: (CGFloat) f {return xExpect(false,self.expectation); }
- (xExpect) isLessThanNumber: (CGFloat) f {return xExpect(false,self.expectation); }
- (xExpect) isGreaterThanNumber: (CGFloat) f {return xExpect(false,self.expectation); }
- (xExpect) isBetween: (CGFloat) f high: (CGFloat) g {return xExpect(false,self.expectation); }

- (xExpectNumber) getDouble: (const string&) attrib
    {return xExpectNumber(0,self.expectation); }

- (xExpectNumber) getLong: (const string&) attrib
{return xExpectNumber(0,self.expectation); }

- (xExpect) getString: (const string&) attrib {return xExpect(false,self.expectation); }
- (xExpect) getBoolean: (const string&) attrib {return xExpect(false,self.expectation); }
- (xExpect) hasSameParent {return xExpect(false,self.expectation); }
- (CGFloat) doubleValue {return 0;}
@end


@interface TbxBooleanExpectation : TbxExpectation
@property(nonatomic,assign) BOOL value;
- (instancetype) initFor: (BOOL) what in: (xExpect*) e;
@end

@interface TbxStringExpectation : TbxExpectation
@property(nonatomic,assign) string value;
- (instancetype) initFor: (const string&) what in: (xExpect*) e;
- (xExpect) isTrue;
- (xExpect) isFalse;
@end



@interface TbxNumericExpectation : TbxExpectation
@property(nonatomic,assign) CGFloat value;
- (instancetype) initFor: (CGFloat) what in: (xExpect*) e;
- (xExpect) isEqualTo: (CGFloat) t;
@end




xExpect::xExpect(const xExpect& t)
:impl(t.impl),line(t.line),file(t.file),test(t.test),message(t.message)
{
    
}

xExpect::xExpect(BOOL flag,const string& inFile, NSInteger inLine,XCTestCase* inTest)
{
    file=inFile;
    line=inLine;
    test=inTest;
    impl=[[TbxBooleanExpectation alloc] initFor: flag in: this];
}

xExpect::xExpect(BOOL flag,const xExpect* t)
{
    file=t->file;
    line=t->line;
    test=t->test;
    message=t->message;
    impl=[[TbxBooleanExpectation alloc] initFor: flag in: this];
}





xExpect::xExpect(const string& s,const xExpect* e)
{
    file=e->file;
    line=e->line;
    test=e->test;
    message=e->message;
    impl=[[TbxStringExpectation alloc] initFor: s in: this];
}

xExpect::xExpect(const string& s,const string& inFile, NSInteger inLine,XCTestCase* inTest)
{
    file=inFile;
    line=inLine;
    test=inTest;
    impl=[[TbxStringExpectation alloc] initFor: s in: this];
}


xExpect::xExpect()
{
    impl=[[TbxExpectation alloc]initWith: this];
}


xExpect::~xExpect()
{

}

BOOL xExpect::Finalize() const
{
    BOOL result=[impl finalize];
    if (!result){
        [test recordFailureWithDescription: message inFile: @(file.c_str()) atLine: line expected:YES];
    }
    return result;
}

BOOL xExpect::FinalizeNegative() const
{
    BOOL result=[impl finalize];
    if (result){
        [test recordFailureWithDescription: message inFile: @(file.c_str()) atLine: line expected:YES];
    }
    return result;
}



xExpect xExpect::IsTrue() const
{
    return [impl isTrue];
}


xExpect xExpect::IsFalse() const
{
    return [impl isFalse];
}

xExpect xExpect::IsNotNil() const
{
    return [impl isTrue];
}

xExpect xExpect::Is(const string& flag) const
{
    return [impl isString: flag];
}




xExpect xExpect::Is(BOOL flag) const
{
    if (flag)
        return [impl isTrue];
    return [impl isFalse];
}

xExpect xExpect::IsNot(const string& flag) const
{
    return [impl isNotString: flag];
}

xExpect xExpect::BeginsWith(const string& flag) const
{
    return [impl beginsWith: flag];
}

xExpect xExpect::EndsWith(const string& flag) const
{
    return [impl endsWith: flag];
}


xExpect xExpect::Contains(const string& flag) const
{
    return [impl contains: flag];
}


xExpectNumber xExpect::Height() const
{
    return [impl height];
}

xExpectNumber xExpect::Width() const
{
    return [impl width];
}

xExpect xExpect::IsEmpty() const
{
    return [impl isEmpty];
}

xExpect xExpect::IsNotEmpty() const
{
    return [impl isNotEmpty];
}

xExpect xExpect::HasSize(NSInteger n) const
{
    return [impl hasSize: n];
}

xExpect xExpect::HasSameParent() const
{
    return [impl hasSameParent];
}


xExpectString::xExpectString(const string& s,const string& inFile, NSInteger inLine,XCTestCase* inTest)
:xExpect(s,inFile,inLine,inTest)
{}

xExpectString::xExpectString(NSString*s,const string& inFile, NSInteger inLine,XCTestCase* inTest)
:xExpect([TbxString for: s],inFile,inLine,inTest)
{}







xExpectView::xExpectView(UIView *v,const string& inFile, NSInteger inLine,XCTestCase* inTest)
:xExpect("",inFile,inLine,inTest),view(v)
{
    
}

xExpectView::xExpectView(UIView *v,const xExpect*e)
:xExpect("",e),view(v)
{
    
}

xExpect xExpectView::IsHidden() const
{
    BOOL hidden=[view isHidden];
    return xExpect(hidden,this);
}

xExpect xExpectView::IsNotHidden() const
{
    return xExpect(![view isHidden],this);
}

xExpect xExpectView::IsNotNil() const
{
    return xExpect(view!=nil,this);
}

xExpect xExpectView::IsEnabled() const
{
    BOOL flag=[(UIControl*)view isEnabled];
    return xExpect(flag,this);
}
xExpect xExpectView::IsDisabled() const
{
    BOOL flag=[(UIControl*)view isEnabled];
    return xExpect(!flag,this);
}



xExpectNumber::xExpectNumber(CGFloat f,const string& inFile, NSInteger inLine,XCTestCase* inTest)
{
    file=inFile;
    line=inLine;
    test=inTest;
    value=f;
    impl=[[TbxNumericExpectation alloc] initFor: f in: this];
}

xExpectNumber::xExpectNumber(const xExpectNumber& it)
{
    file=it.file;
    line=it.line;
    test=it.test;
    message=it.message;
    value=it.value;
    impl=it.impl;
}

xExpectNumber::xExpectNumber(CGFloat f,  const xExpect* e)
{
    file=e->file;
    line=e->line;
    test=e->test;
    message=e->message;
    value=f;
    impl=[[TbxNumericExpectation alloc] initFor: f in: this];
}

xExpect xExpectNumber::Is(CGFloat f) const
{
    return [impl isEqualTo: f];
}

xExpect xExpectNumber::IsNot(CGFloat f) const
{
    return xExpect(value!=f,this);
}

xExpectNumber::operator CGFloat() const
{
    return [impl doubleValue];
}

xExpect xExpectNumber::IsLessThan(CGFloat f) const
{
    return [impl isLessThanNumber: f];
}

xExpect xExpectNumber::IsGreaterThan(CGFloat f) const
{
    return [impl isGreaterThanNumber: f];
}

xExpect xExpectNumber::IsBetween(CGFloat low,CGFloat high) const
{
    return [impl isBetween: low high: high];
}

xExpect xExpectNumber::IsCloseTo(CGFloat target) const
{
    CGFloat low=0.99*target;
    CGFloat high=1.01*target;
    return [impl isBetween: low high: high];
}





xExpectArray::xExpectArray(NSArray* inArray,const string& inFile, NSInteger inLine,XCTestCase* inTest)
:xExpect("",inFile,inLine,inTest),val(inArray)
{}

xExpectArray::xExpectArray(NSArray *inArray,xExpect* inExpect)
:xExpect("",inExpect),val(inArray)
{}

xExpect xExpectArray::HasSize(NSInteger n) const
{
    if (n!=val.count) {
        message=[NSString stringWithFormat: @"Array has %ld elements, not %ld",val.count,n];
    }
    return xExpect(n==val.count,this);
}


xExpect xExpectArray::Has(NSString* s) const
{
    BOOL found=[val containsObject: s];
    if (!found) {
        message=[NSString stringWithFormat: @"Should  have %@",s];
    }
    return xExpect(found,this);
}

xExpect xExpectArray::DoesNotHave(NSString* s) const
{
    BOOL found=[val containsObject: s];
    if (found) {
        message=[NSString stringWithFormat: @"Should not have %@, but does.",s];
    }
    return xExpect(!found,this);
}



#pragma mark -


@implementation TbxBooleanExpectation

- (instancetype) initFor: (BOOL) flag in: (xExpect*) e
{
    self=[super initWith: e];
    if (self) {
        _value=flag;
    }
    return self;
}

- (BOOL) finalize {
    return self.value;
}


- (xExpect) isTrue {return xExpect(self.value,self.expectation);}
- (xExpect) isFalse {return xExpect(!self.value,self.expectation);}
- (xExpect) is: (BOOL) flag {return xExpect(self.value==flag,self.expectation);}

@end


@implementation TbxStringExpectation

- (instancetype) initFor: (const string&) inString in: (xExpect*) e
{
    self=[super initWith: e];
    if (self) {
        _value=inString;
    }
    return self;
}

- (BOOL) finalize {
    return !self.value.empty();
}


- (xExpect) isString: (const string&) what {
    BOOL result=self.value==what;
    if (!result) {
        [self recordFailure:@"%s is not %s",self.value.c_str(),what.c_str()];
    }
    return xExpect(result,self.expectation);
}
- (xExpect) isNotString: (const string&) what {
    BOOL result=self.value!=what;
    if (result) {
        [self recordFailure:@"%s is wrong",self.value.c_str(),what.c_str()];
    }
    return xExpect(result,self.expectation);
}


- (xExpect) beginsWith: (const string&) what {
    BOOL result= (self.value.find(what)==0);
    if (!result) {
        [self recordFailure:@"%s doesn't begin with %s",self.value.c_str(),what.c_str()];
    }
    return xExpect(result,self.expectation);
}

- (xExpect) endsWith: (const string&) what {
    BOOL result= (self.value.substr(self.value.length()-what.length())==what);
    if (!result) {
        [self recordFailure:@"%s doesn't end with %s",self.value.c_str(),what.c_str()];
    }
    return xExpect(result,self.expectation);
}

- (xExpect) contains: (const string&) what {
    BOOL result=self.value.find(what)!=string::npos;
    if (!result) {
        [self recordFailure:@"%s doesn't contain %s",self.value.c_str(),what.c_str()];
    }
    return xExpect(result,self.expectation);
}

- (xExpect) hasSize: (NSInteger) n
{
    return xExpect(self.value.length()==n,self.expectation);
}

- (xExpect) isTrue
{
    BOOL result= !(self.value.empty());
    return xExpect(result,self.expectation);
}

- (xExpect) isFalse
{
    BOOL result= (self.value.empty());
    return xExpect(result,self.expectation);
}

- (xExpect) isEmpty
{
    BOOL result=self.value.empty();
    if (!result) {
        [self recordFailure:@"%s is not empty",self.value.c_str()];
    }
    return xExpect(result,self.expectation);
}


- (xExpect) isNotEmpty
{
    BOOL result=!self.value.empty();
    if (!result) {
        [self recordFailure:@"should not be empty"];
    }
    return xExpect(result,self.expectation);
}

@end



@implementation TbxNumericExpectation


- (instancetype) initFor: (CGFloat) f in: (xExpect*) e
{
    self=[super initWith: e];
    if (self) {
        _value=f;
    }
    return self;
}

- (xExpect) isEqualTo: (CGFloat) f
{
    BOOL result=self.value==f;
    if (!result) {
        [self recordFailure:@"%.1f isn’t %.1f",self.value,f];
    }
    return xExpect(result,self.expectation);
}



- (xExpect) isGreaterThanNumber: (CGFloat) f
{
    BOOL result=self.value>f;
    if (!result) {
        [self recordFailure:@"%.1f isn’t less than %.1f",self.value,f];
    }
    return xExpect(result,self.expectation);
}

- (xExpect) isLessThanNumber: (CGFloat) f
{
    BOOL result=self.value<f;
    if (!result) {
        [self recordFailure:@"%.1f isn’t less than %.1f",self.value,f];
    }
    return xExpect(result,self.expectation);
}


- (xExpect) isBetween: (CGFloat) low high: (CGFloat) high
{
    BOOL result=self.value>=low && self.value <= high;
    if (!result) {
        [self recordFailure:@"%.3f isn’t between %.3f and %.3f",self.value,low,high];
    }
    return xExpect(result,self.expectation);
}


- (CGFloat) doubleValue { return self.value;}


@end
