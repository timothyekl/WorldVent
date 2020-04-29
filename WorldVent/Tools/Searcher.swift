//
//  Searcher.swift
//  WorldVent
//
//  Created by mark bernstein on 4/29/20.
//  Copyright © 2020 Tim Ekl. All rights reserved.
//


import Foundation

public struct Searcher {
    
    private var basePath:String;
    private var query:String;
    public init(path: String,for searchString: String) {
        basePath=path;
        query=searchString
    }
    
    
    public var results:Array<WebSearchResult> {
        let f=HTFile(path:basePath)
        let files=f.allFiles
        var results=Array<WebSearchResult>()
        for file in files {
            let theFile=HTFile(path:file);
            if let text=theFile.styledText {
                let stext=text.string;
                if let range = stext.range(of: query, options: .caseInsensitive) {

                    results.append(WebSearchResult(matchPhrase: query, detailText: "not yet", resultFilePath: theFile.path) )
                }
            }
            
        }
        return results
    }
    
}
