//
//  Manifest.swift
//  WorldVent
//
//  Created by Timothy Ekl on 4/15/20.
//  Copyright © 2020 Tim Ekl. All rights reserved.
//

import Foundation

/// A Bulletin is a notice from the server about some piece of news.
struct Bulletin: Decodable {
    var url: URL
    var published: Date
}

/// A Manifest is the top-level index of content available to the app.
struct Manifest: Decodable {
    var lastUpdated: Date
    var bulletin: Bulletin
}

/// Content is a snapshot of an entire documentation ("content") directory.
struct Content {
    enum Source {
        case bundle
        case networkHost(URL)
    }
    let source: Source
    
    let manifest: Manifest
    var date: Date {
        return manifest.lastUpdated
    }
}
