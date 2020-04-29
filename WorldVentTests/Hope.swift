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

public func Hope(_ expression: @autoclosure () throws -> Bool, _ message: @autoclosure ()  -> String = "", file: StaticString = #file, line: UInt = #line){
    try?XCTAssert(expression(), message(),file:file,line:line)
}


// TODO better failure messages. message instance value; pass message for failure to next ThatX in chain

public struct ThatBoolean
{
    let value:Bool
    let message:String
    
    init(_ inVal:Bool) {
        value=inVal
        message=""
    }
    
    init(_ inVal:Bool,message: String) {
        self.value=inVal
        self.message=message
    }
    
    init(_ inVal:ThatBoolean){
        value=inVal.isTrue
        message=inVal.message
    }
    
    var isTrue: Bool { return value;}
    var isFalse: Bool { return !value;}

}

public func Hope(_ expression: ThatBoolean, file: StaticString = #file, line: UInt = #line){   
    XCTAssert(expression.isTrue, expression.message,file:file,line:line)
}


public struct ThatString
{
    let value:String
    init(_ inVal:String) {
        value=inVal
    }
    
    var isTrue: ThatBoolean { return ThatBoolean(value != "");}
    var isFalse: ThatBoolean { return ThatBoolean(value == "");}
    var isEmpty: ThatBoolean {return isFalse}
    
    func contains(_ s:String)->ThatBoolean {
        let message="\(value) doesn't contain \(s)";
        return ThatBoolean(value.contains(s),message: message)
    }
    
    func isEqualTo(_ s:String)->ThatBoolean {
        let message="\(value) is not \(s)";
        return ThatBoolean(value==s,message: message)
    }
    
    func isGreaterThan(_ s:String)->ThatBoolean {
        let message="\(value) is not  greater than \(s)";

        return ThatBoolean(value>s,message:message)
    }
    
    func isLessThan(_ s:String)->ThatBoolean {
        let message="\(value) is not  less than \(s)";

        return ThatBoolean(value<s,message:message)
    }
    
    func isNot(_ s:String)->ThatBoolean {
        let message="\(value) is unexpectedly equal to \(s)";
        return ThatBoolean(value != s,message:message)
    }
    
    var length:ThatNumber {
        let message="length of \(value) is not "
        return ThatNumber(Double(value.count),message:message)
    }
    
}

public struct ThatNumber
{
    let value:Double
    let message:String;
    init(_ inVal:Double) {
        value=inVal
        message="";
    }
    init(_ inVal:Int) {
        value=Double(inVal)
        message="";
    }
    init(_ inVal:Int,message:String) {
        self.value=Double(inVal)
        self.message=message;
       }
    init(_ inVal:Double,message:String) {
           self.value=inVal
           self.message=message;
          }

    func isEqualTo(_ s:Double)->ThatBoolean {
        var m=message;
        if (message.isEmpty) {
            m="\(value) is not \(s)"
        }
        else {
            m=self.message+"\(s)"
        }
        return ThatBoolean(value==s,message:m)
    }
    func isEqualTo(_ s:Int)->ThatBoolean {
        var m=message;
        if (message.isEmpty) {
           m="\(value) is not \(s)"
        }
        else {
           m=self.message+"\(s)"
        }
        return ThatBoolean(value==Double(s),message: m)
    }
    func isNot(_ s:Double)->ThatBoolean {
        var m=message;
        if (message.isEmpty) {
           m="\(value) should not be \(s)"
        }
        else {
           m=self.message+"\(s)"
        }
        return ThatBoolean(value != s,message:m)
    }
    func isNot(_ s:Int)->ThatBoolean {
        var m=message;
        if (message.isEmpty) {
           m="\(value) should not be \(s)"
        }
        else {
           m=self.message+"\(s)"
        }
        return ThatBoolean(value != Double(s),message:m)
    }
    func isGreaterThan(_ s:Double)->ThatBoolean {
        var m=message;
        if (message.isEmpty) {
          m="\(value) is not > \(s)"
        }
        else {
          m=self.message+"\(s)"
        }
        return ThatBoolean(value>s,message: m)
       }
    func isLessThan(_ s:Double)->ThatBoolean {
        var m=message;
        if (message.isEmpty) {
          m="\(value) is not < \(s)"
        }
        else {
          m=self.message+"\(s)"
        }
        return ThatBoolean(value<s,message:m)
      }
}

public struct ThatArray
{
    let value: Array<String>
    let message:String;
    init(_ inVal:Array<String>) {
        value=inVal
        message="";
       }
    init(_ inVal:Array<String>,message:String) {
        self.value=inVal
        self.message=message;
        }
    
    var count:ThatNumber {
        return ThatNumber(Double(value.count))
    }
    func hasSize(_ s:Int)->ThatBoolean {
        var m=message;
        if (message.isEmpty) {
            m="Array has size \(value.count) should have  \(s)"
        }
        return ThatBoolean(value.count==s,message:m)
    }
    
    func contains(_ s:String)->ThatBoolean {
        var m=message;
        if (message.isEmpty) {
            m="Array doesn't contain \(s)"
            }
        return ThatBoolean(value.contains(s),message:m)
    }
    
    var isEmpty:ThatBoolean {
        var m=message;
        if (message.isEmpty) {
           m="Array[\(value.count)] should be empty"
           }
        return ThatBoolean(value.isEmpty,message:m)
    }
    
    var isNotEmpty:ThatBoolean {
        var m=message;
        if (message.isEmpty) {
          m="Array should not be empty"
          }
        return ThatBoolean(!value.isEmpty,message:m)
       }
    
}


public struct ThatView
{
    let value: UIView?
    init(_ inVal:UIView?) {
           value=inVal
       }
    
    var isHidden:ThatBoolean {
        if let v=value {
            return ThatBoolean(v.isHidden)
        }
        else {return ThatBoolean(false)}
    }
    
    var width:ThatNumber {
        if let v=value {
            return ThatNumber(Double(v.frame.size.width))
        }
        return ThatNumber(0)
    }
    var height:ThatNumber {
        if let v=value{
            return ThatNumber(Double(v.frame.size.height))
        }
        return ThatNumber(0)
    }
    
    var superview:ThatView {
        return ThatView(value?.superview)
    }
    
    var isNil : ThatBoolean {
        return ThatBoolean(value==nil)
    }
}




// MARK: WorldVent specific

public struct ThatHTFile {
    let value: HTFile
    let message:String;
    
    init(_ inVal:HTFile) {
          value=inVal
        message="";
      }
    init(_ inVal:HTFile,message: String) {
        value=inVal
        self.message=message;
      }
    init(_ inVal:String) {
        value=HTFile(path: inVal)
        message="";
    }
    init(_ inVal:String,message:String) {
        value=HTFile(path: inVal)
        self.message=message;
       }
    var exists: ThatBoolean {
        var m=message;
        if (message.isEmpty){
            m="\(value.path) doesn’t exist";
        }
        return ThatBoolean(value.exists,message:m)
    }
    
    var allFiles: ThatArray {
        return ThatArray(value.allFiles);
       }
    
    
       
}
