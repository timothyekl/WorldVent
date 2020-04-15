//
//  ContentManager.swift
//  WorldVent
//
//  Created by Timothy Ekl on 4/14/20.
//  Copyright © 2020 Tim Ekl. All rights reserved.
//

import Foundation

/// ContentManager is the singleton entry point for all HTML/JS content in the app.
/// It manages both the initial set of documentation shipped in the app bundle and subsequent updates fetched from a server.
class ContentManager {
    static let shared = ContentManager()
    
    private var contents: [Content] = []
    var latestContent: Content! {
        return contents.max(by: { $0.date < $1.date })
    }
    
    private var cacheURL: URL
    
    /// Create a new ContentManager that stores its content in subdirectories of the given URL.
    private init(cacheURL: URL? = nil) {
        let fallbackURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first?.appendingPathComponent("content")
        guard let resolvedURL: URL = cacheURL ?? fallbackURL else {
            fatalError("Nowhere to store content")
        }
        self.cacheURL = resolvedURL
        
        do {
            try populateAppContentIfNeeded()
        } catch {
            fatalError("Error reading app content from the bundle: \(error)")
        }
    }
    
    /// Copy the content directory that shipped with the app into the managed folder, if necessary
    private func populateAppContentIfNeeded() throws {
        fatalError("Unimplemented")
    }
}
