//
//  Spider.swift
//  WorldVentTests
//
//  Created by mark bernstein on 4/25/20.
//  Copyright © 2020 Tim Ekl. All rights reserved.
//

import WorldVent
import Foundation

class Spider {
    private(set) var paths=Set<String>()
    private(set) var missing=Set<String>()
    private var unvisited=Set<String>()

    private let start:String;
    
    init(start:String) {
        self.start=start
        crawl()
    }
    
    private func crawl() {
        unvisited.removeAll();
        unvisited.insert(self.start)
        while (!unvisited.isEmpty) {
            let next=unvisited.removeFirst()
            traverse(next)
        }
    }
    
    fileprivate func traverse( _ next: String) {
        let f=HTFile(path:next);
        if (!f.exists) {
             missing.insert(next)
            return;
        }
        paths.insert(next);
        let links=f.links;
        for link in links {
            if (hasBeenScheduled(link)) {continue;}
            unvisited.insert(link);
        }
    }
    
    fileprivate func hasBeenScheduled(_ page:String) ->Bool {
        if (unvisited.contains(page)){ return true;}
        if (paths.contains(page)) {return true;}
        return false;
    }

}
