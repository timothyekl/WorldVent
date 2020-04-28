//
//  HTFileTests.swift
//  WorldVentTests
//
//  Created by mark bernstein on 4/23/20.
//  Copyright © 2020 Tim Ekl. All rights reserved.
//

import WorldVent
import XCTest

class HTFileTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExists() throws {
        let index=HTFile(path:"index.html")
        let bad=HTFile(path:"albatross");
        Hope(ThatHTFile(index).exists);
        Hope(ThatHTFile(bad).exists.isFalse);
    }

    func testHTML() throws {
        let index=HTFile(path:"index.html")
        let s=index.html;
        Hope(ThatString(s).contains("<html"));
        Hope(ThatString(s).contains("<body"));
        Hope(ThatString(s).contains("Kareem").isFalse);
    }
    
    func testExtractHref() throws {
        let tag="<a href=\"go.html\">test</a>"
        let f=HTFile(path:"albatross")
        let result=f.extractHref(tag:tag);
        Hope(ThatString(result).isEqualTo("go.html"));
    }

    func testThatIndexHasStyleSheet(){
        let index=HTFile(path: "index.html")
        let sheets=index.stylesheets;
        Hope(ThatArray(sheets).count.isNot(0));
        Hope(ThatArray(sheets).contains("./css/screen.css"));
    }

    
    func testThatIndexLinksExist(){
        let index=HTFile(path:"index.html");
        let links=index.links;
        XCTAssertFalse(links.count==0);
        for path in links {
            Hope(ThatHTFile(HTFile(path:path)).exists);
        }
    }
    
    func testThatIndexHasViewport() {
        let index=HTFile(path:"index.html");
        let tag=index.viewport;
        Hope(ThatString(tag).isEmpty.isFalse);
    }
    
    func testThatIndexHasH1() {
        let index=HTFile(path:"doc/index.html");    // because today the overall index has an H2!
        let headings=index.headings;
        Hope(ThatArray(headings).count.isEqualTo(1));
        Hope(ThatArray(headings).contains("Overview"));
    }
    
    func testFileDiscovery() {
        let root=HTFile(path:"Documentation");
        let paths=root.allFiles;
        Hope(ThatArray(paths).isNotEmpty);
        Hope(ThatArray(paths).contains("index.html"));
        Hope(ThatArray(paths).contains("doc/index.html"));

    }
    
    
}

