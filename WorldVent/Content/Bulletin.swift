//
//  Manifest.swift
//  WorldVent
//
//  Created by Timothy Ekl on 4/15/20.
//  Copyright © 2020 Tim Ekl. All rights reserved.
//

import Foundation

/// A Bulletin is a notice from the server about some piece of news.
struct Bulletin {
    struct Metadata: Decodable {
        var url: URL
        var published: Date
    }
    var metadata: Metadata
    
    enum Source {
        case cache(URL)
        case server(URL)
    }
    var source: Source
    
    var sourceURL: URL {
        let url: URL
        switch source {
        case .cache(let u): url = u
        case .server(let u): url = u
        }
        return url.absoluteURL
    }
    
    var contentsURL: URL {
        return URL(string: metadata.url.relativeString, relativeTo: sourceURL) ?? metadata.url
    }
}
