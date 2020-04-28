//
//  Hope.swift
//  WorldVentTests
//
//  Created by mark bernstein on 4/27/20.
//  Copyright © 2020 Tim Ekl. All rights reserved.
//

import WorldVent
import XCTest
import Foundation

public func Hope(_ expression: @autoclosure () throws -> Bool, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line){
    try?XCTAssert(expression(), message(),file:file,line:line)
}


public struct ThatBoolean
{
    let value:Bool;
    
    init(_ inVal:Bool) {
        value=inVal;
    }
    
    init(_ inVal:ThatBoolean){
        value=inVal.isTrue;
    }
    
    var isTrue: Bool { return value;}
    var isFalse: Bool { return !value;}

}

public func Hope(_ expression: @autoclosure () throws -> ThatBoolean, _ message: @autoclosure () -> String = "", file: StaticString = #file, line: UInt = #line){
    try?XCTAssert(expression().isTrue, message(),file:file,line:line)
}


public struct ThatString
{
    let value:String;
    init(_ inVal:String) {
        value=inVal;
    }
    
    var isTrue: ThatBoolean { return ThatBoolean(value != "");}
    var isFalse: ThatBoolean { return ThatBoolean(value == "");}
    var isEmpty: ThatBoolean {return isFalse}
    
    func contains(_ s:String)->ThatBoolean {
        return ThatBoolean(value.contains(s))
    }
    
    func isEqualTo(_ s:String)->ThatBoolean {
    return ThatBoolean(value==s);
    }
    
    func isGreaterThan(_ s:String)->ThatBoolean {
    return ThatBoolean(value>s);
    }
    
    func isLessThan(_ s:String)->ThatBoolean {
    return ThatBoolean(value<s);
    }
    
    func isNot(_ s:String)->ThatBoolean {
        return ThatBoolean(value != s);
    }
    
    var length:ThatNumber {
        return ThatNumber(Double(value.count))
    }
    
}

public struct ThatNumber
{
    let value:Double;
    init(_ inVal:Double) {
        value=inVal;
    }
    

    func isEqualTo(_ s:Double)->ThatBoolean {
        return ThatBoolean(value==s);
    }
    func isNot(_ s:Double)->ThatBoolean {
        return ThatBoolean(value != s);
    }
    func isGreaterThan(_ s:Double)->ThatBoolean {
        return ThatBoolean(value>s);
       }
    func isLessThan(_ s:Double)->ThatBoolean {
          return ThatBoolean(value<s);
      }
}

public struct ThatArray
{
    let value: Array<String>;
    init(_ inVal:Array<String>) {
           value=inVal;
       }
    
    var count:ThatNumber {return ThatNumber(Double(value.count))}
    func hasSize(_ s:Int)->ThatBoolean {
        return ThatBoolean(value.count==s)
    }
    
    func contains(_ s:String)->ThatBoolean {
        return ThatBoolean(value.contains(s));
    }
}


public struct ThatView
{
    let value: UIView?;
    init(_ inVal:UIView?) {
           value=inVal;
       }
    
    var isHidden:ThatBoolean {
        if let v=value {
            return ThatBoolean(v.isHidden)
        }
        else {return ThatBoolean(false)}
    }
    
    var width:ThatNumber {
        if let v=value {
            return ThatNumber(Double(v.frame.size.width));
        }
        return ThatNumber(0)
    }
    var height:ThatNumber {
        if let v=value{
            return ThatNumber(Double(v.frame.size.height));
        }
        return ThatNumber(0);
    }
    
    var superview:ThatView {
        return ThatView(value?.superview);
    }
    
    var isNil : ThatBoolean {
        return ThatBoolean(value==nil);
    }
}




// MARK: WorldVent specific

public struct ThatHTFile {
    let value: HTFile;
    init(_ inVal:HTFile) {
          value=inVal;
      }
    
    var exists: ThatBoolean {
        return ThatBoolean(value.exists);
    }
    
    
       
}
