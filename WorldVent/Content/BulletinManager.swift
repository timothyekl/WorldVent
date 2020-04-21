//
//  BulletinManager.swift
//  WorldVent
//
//  Created by Timothy Ekl on 4/14/20.
//  Copyright © 2020 Tim Ekl. All rights reserved.
//

import Foundation

/// BulletinManager is the singleton entry point for managing "bulletin" notices from the server.
/// It sources from both the initial set of documentation shipped in the app bundle and subsequent updates fetched from a server.
class BulletinManager: NSObject, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDownloadDelegate, URLSessionDataDelegate {
    static let shared = BulletinManager()
    
    /// Indicates the bulletin itself did change, in URL or publication date.
    static let bulletinDidChangeNotification = NSNotification.Name("com.timekl.worldvent.BulletinManager.BulletinDidChange")
    /// Indicates the bulletin metadata remains the same, but its contents have changed somehow. Notably, this is posted after downloading bulletin contents from a server.
    static let contentsDidChangeNotification = NSNotification.Name("com.timekl.worldvent.BulletinManager.ContentsDidChange")
    /// Indicates the date of the last seen bulletin has changed.
    static let lastSeenDateDidChangeNotification = NSNotification.Name("com.timekl.worldvent.BulletinManager.LastSeenDateDidChange")
    
    private static let appBundleDirectoryPrefix = "Documentation"
    
    private(set) var latestBulletin: Bulletin? {
        willSet {
            dispatchPrecondition(condition: .onQueue(.main))
        }
        didSet {
            NotificationCenter.default.post(name: Self.bulletinDidChangeNotification, object: self)
        }
    }
    
    private var cacheURL: URL
    
    private var _urlSessionQueue = DispatchQueue(label: "com.timekl.worldvent.BulletinManager.URLSessionQueue")
    
    private lazy var urlSessionQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.underlyingQueue = _urlSessionQueue
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    private lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: self.urlSessionQueue)
        return session
    }()
    
    /// Create a new ContentManager that stores its content in subdirectories of the given URL.
    init(cacheURL: URL? = nil) {
        let fallbackURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
        guard let resolvedURL: URL = cacheURL ?? fallbackURL else {
            fatalError("Nowhere to store content")
        }
        self.cacheURL = resolvedURL
        
        super.init()
        
        do {
            try populateAppContentIfNeeded()
        } catch {
            assertionFailure("Error reading app content from the bundle: \(error)")
        }
    }
    
    // MARK: Cache management
    
    /// User defaults key for the last CFBundleVersion at which the cache was updated.
    private static let lastCacheUpdateKey = "LastCacheUpdate"
    
    /// Returns `true` if the existing cache can be reused for the current app, or `false` otherwise.
    private var isCacheValidForBuild: Bool {
        guard let lastCacheUpdate = UserDefaults.standard.string(forKey: Self.lastCacheUpdateKey) else {
            return false
        }
        
        guard let bundleVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String else {
            assertionFailure("How did we get a bundle shipping without a bundle version?")
            return false
        }
        
        guard bundleVersion == lastCacheUpdate else {
            return false
        }
        
        return true
    }
    
    /// Copy the content directory that shipped with the app into the managed folder, if necessary
    private func populateAppContentIfNeeded() throws {
        if isCacheValidForBuild {
            // No need to do any work here
            return
        }
        
        do {
            try FileManager.default.removeItem(at: cacheURL)
        } catch let error where error.causedByMissingFile {
            // swallow this error; we wanted to remove a file that was already gone, and that's fine
        }
        
        guard let url = Bundle.main.url(forResource: Self.appBundleDirectoryPrefix, withExtension: nil) else {
            fatalError("Unable to locate resources in app bundle. Check build configuration.")
        }
        
        try FileManager.default.copyItem(at: url, to: cacheURL) // both directories, so copies contents
    }
    
    // MARK: Bulletin loading
    
    private static let bulletinServerURLString = "https://worldvent.timekl.com/"
    private static let bulletinIndexSuffix = "bulletins/index.json"
    
    private static let bulletinDownloadDescription = "com.timekl.worldvent.BulletinManager.downloadIndexJSON"
    private static let contentsDownloadDescription = "com.timekl.worldvent.BulletinManager.downloadContents"
    
    /// Loads the latest bulletin from the local cache synchronously.
    func loadCachedBulletin() throws {
        let indexURL = URL(fileURLWithPath: Self.bulletinIndexSuffix, relativeTo: cacheURL)
        let indexData = try Data(contentsOf: indexURL)
        let metadata = try loadBulletinMetadata(from: indexData)
        self.latestBulletin = Bulletin(metadata: metadata, source: .cache(indexURL))
    }
    
    private func loadBulletinMetadata(from data: Data) throws -> Bulletin.Metadata {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let metadata = try decoder.decode(Bulletin.Metadata.self, from: data)
        return metadata
    }
    
    /// Begins a data request to the server to get the latest bulletin JSON.
    func requestServerBulletin() {
        urlSessionQueue.addOperation { [weak self] in
            guard let self = self else { return }
            
            guard self.accumulatingBulletinData == nil else {
                assertionFailure("Request already in progress")
                return
            }
            
            let serverURL = URL(string: Self.bulletinServerURLString)!
            let url = URL(string: Self.bulletinIndexSuffix, relativeTo: serverURL)!
            let task = self.urlSession.dataTask(with: url)
            task.taskDescription = Self.bulletinDownloadDescription
            self.accumulatingBulletinData = Data()
            task.resume()
        }
    }
    
    func loadContents(of bulletin: Bulletin, completion: (Data?, Error?) -> Void) {
        let contentsFileURL = self.contentsFileURL(for: bulletin)
        assert(contentsFileURL.isFileURL)
        
        do {
            let data = try Data(contentsOf: contentsFileURL)
            completion(data, nil)
        } catch {
            completion(nil, error)
        }
    }
    
    private func contentsFileURL(for bulletin: Bulletin) -> URL {
        switch bulletin.source {
        case .cache(_):
            return bulletin.contentsURL
        case .server(let url):
            return hashedContentsFileURL(for: url)
        }
    }
    
    private func hashedContentsFileURL(for serverURL: URL) -> URL {
        // TODO: vary this with the actual server URL
        return cacheURL.appendingPathComponent("latest-server-bulletin").appendingPathExtension("html")
    }
    
    // MARK: Last viewed bulletins
    
    private static let lastSeenBulletinDateKey = "LastSeenBulletinDate"
    
    private var lastSeenBulletinDate: Date {
        get {
            let timeInterval = UserDefaults.standard.double(forKey: Self.lastSeenBulletinDateKey)
            return Date(timeIntervalSince1970: timeInterval)
        }
        set {
            UserDefaults.standard.set(newValue.timeIntervalSince1970, forKey: Self.lastSeenBulletinDateKey)
            NotificationCenter.default.post(name: Self.lastSeenDateDidChangeNotification, object: self)
        }
    }
    
    func hasSeenBulletin(at date: Date) -> Bool {
        return date <= lastSeenBulletinDate
    }
    
    func setLastSeenBulletin(_ bulletin: Bulletin) {
        lastSeenBulletinDate = bulletin.metadata.published
    }
    
    // MARK: URLSessionDelegate
    
    private var accumulatingBulletinData: Data? {
        willSet {
            dispatchPrecondition(condition: .onQueue(_urlSessionQueue))
        }
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        dispatchPrecondition(condition: .onQueue(_urlSessionQueue))
        
        guard task.taskDescription == Self.bulletinDownloadDescription else {
            return
        }
        
        defer {
            accumulatingBulletinData = nil
        }
        
        if let error = error {
            // TODO: error handling? os_log?
            return
        }
        
        do {
            let metadata = try loadBulletinMetadata(from: accumulatingBulletinData!)
            let bulletin = Bulletin(metadata: metadata, source: .server(task.originalRequest!.url!))
            
            let contentsTask = urlSession.downloadTask(with: bulletin.contentsURL)
            contentsTask.taskDescription = Self.contentsDownloadDescription
            contentsTask.resume()
            
            DispatchQueue.main.async {
                if let current = self.latestBulletin {
                    if bulletin.metadata.published > current.metadata.published {
                        self.latestBulletin = bulletin
                    }
                } else {
                    self.latestBulletin = bulletin
                }
            }
        } catch {
            // TODO: error handling? os_log?
            assertionFailure("Unexpected JSON contents of bulletin index JSON: \(error)")
            return
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        dispatchPrecondition(condition: .onQueue(_urlSessionQueue))
        assert(accumulatingBulletinData != nil, "Expected to be accumulating bulletin data by the time the data task returns contents")
        accumulatingBulletinData?.append(data)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        dispatchPrecondition(condition: .onQueue(_urlSessionQueue))
        
        guard downloadTask.taskDescription == Self.contentsDownloadDescription else {
            return
        }
        
        do {
            let destinationURL = hashedContentsFileURL(for: downloadTask.originalRequest!.url!)
            try FileManager.default.moveItem(at: location, to: destinationURL)
            NotificationCenter.default.post(name: Self.contentsDidChangeNotification, object: self)
        } catch {
            // TODO: error handling? os_log?
            return
        }
    }
}

// MARK: -

extension Error {
    func hasUnderlyingDomain(_ domain: String, code: Int) -> Bool {
        let nsError = self as NSError
        return nsError.domain == domain && nsError.code == code
    }
    
    var causedByMissingFile: Bool {
        if self.hasUnderlyingDomain(NSCocoaErrorDomain, code: NSFileNoSuchFileError) { return true }
        if self.hasUnderlyingDomain(NSPOSIXErrorDomain, code: Int(ENOENT)) { return true }
        return false
    }
}
