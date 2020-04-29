//
//  SearchTests.swift
//  WorldVentTests
//
//  Created by mark bernstein on 4/29/20.
//  Copyright © 2020 Tim Ekl. All rights reserved.
//

import WorldVent
import XCTest

class SearchTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearcher()  {
        let searcher=Searcher(path: "/",for: "Hannaford");
        let results=searcher.results;
        Hope(!results.isEmpty)
    }
    
    func testThatSearcherIsNotCaseSensitive() {
        let searcher=Searcher(path: "/",for: "Hannaford");
        let caps=searcher.results;
        let searcher2=Searcher(path: "/",for: "hannaford");
        let noCaps=searcher2.results;
        Hope(ThatNumber(caps.count).isEqualTo(noCaps.count))



    }

    
    
    

}
