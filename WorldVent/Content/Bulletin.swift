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
    
    var url: URL {
        let baseURL: URL
        switch source {
        case .cache(let url): baseURL = url
        case .server(let url): baseURL = url
        }
        
        return URL(string: metadata.url.relativeString, relativeTo: baseURL) ?? metadata.url
    }
    
    func loadContents(completion: (Data?, Error?) -> Void) {
        switch source {
        case .cache(_):
            do {
                let data = try Data(contentsOf: url, options: [])
                completion(data, nil)
            } catch {
                completion(nil, error)
            }
            
        case .server(_):
            fatalError("Unimplemented")
        }
    }
}
