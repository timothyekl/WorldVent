//
//  SpiderTests.swift
//  WorldVentTests
//
//  Created by mark bernstein on 4/25/20.
//  Copyright © 2020 Tim Ekl. All rights reserved.
//

import WorldVent
import XCTest



class SpiderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSpider() throws {
        let spider=Spider(start: "index")
        XCTAssertNotNil(spider.paths);
        XCTAssertTrue(spider.paths.contains("/app/Bulletins.html"));
        XCTAssertTrue(spider.paths.contains("/doc/index.html"));
        XCTAssertFalse(spider.paths.contains("/frogs/bullfrog.html"));
        XCTAssertTrue(spider.missing.count==0);
    }
    
    func testThatReachablePagesHaveRequiredElements() throws {
        let spider=Spider(start:"index");
        for path in spider.paths {
            let f=HTFile(path:path);
            XCTAssertFalse(f.viewport=="","no viewport \(path)");
            XCTAssertTrue(f.headings.count==1,"no h1 \(path)");
            XCTAssertTrue(f.stylesheets.count>0,"no stylesheet \(path)");
            XCTAssertFalse(f.stylesheets.first(where:{$0.contains("screen.css")})==nil,"missing screen.css \(path)");
        }
    }

    

}
