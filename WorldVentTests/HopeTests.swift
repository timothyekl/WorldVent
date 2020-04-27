//
//  HopeTests.swift
//  WorldVentTests
//
//  Created by mark bernstein on 4/27/20.
//  Copyright © 2020 Tim Ekl. All rights reserved.
//

import XCTest
import Foundation
import UIKit

class HopeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testHope() throws {
        Hope(1==1,"no soap");
        Hope(ThatBoolean(true).isTrue);
        Hope(ThatBoolean(false).isFalse);
        Hope(ThatBoolean(true));
    }
    
    func testThatString() throws {
        Hope(ThatString("zonker").isTrue);
        Hope(ThatString("").isFalse);
        Hope(ThatString("").isEmpty);
        Hope(ThatString("yes").isEmpty.isFalse);

        Hope(ThatString("zonker").contains("ke"))
        Hope(ThatString("zonker").contains("y").isFalse)
        Hope(ThatString("zonker").isEqualTo("zonker"));
        
        Hope(ThatString("zonker").length.isEqualTo(6));
        Hope(ThatString("zonker").isGreaterThan ("zelda"));
    }
    
    func testThatNumber() throws {
        Hope(ThatNumber(2).isEqualTo(1+1));
        Hope(ThatNumber(3.1415927).isNot(3));
        Hope(ThatNumber(45).isGreaterThan(6));
    }
    

    func testThatArray() throws {
        let a=["Winken","Blinken","Nod"];
        Hope(ThatArray(a).count.isEqualTo(3));
        Hope(ThatArray(a).hasSize(3));
        Hope(ThatArray(a).contains("Winken"));
        Hope(ThatArray(a).contains("Xanadu").isFalse);
    }
    
    func testThatView() throws {
        let rect=CGRect(x:10,y:10,width:500,height:250);
        let v=UIView(frame:rect);
        v.isHidden=true;
        Hope(ThatView(v).isHidden);
        v.isHidden=false;
        Hope(ThatView(v).isHidden.isFalse);
        Hope(ThatView(v).width.isEqualTo(500));

    }
    

}
