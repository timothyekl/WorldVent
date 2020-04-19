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
    
    enum Source {
        case bundle
        case server(URL)
    }
}
