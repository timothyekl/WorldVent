//
//  BulletinViewController.swift
//  WorldVent
//
//  Created by Tim Ekl on 4/18/20.
//  Copyright © 2020 Tim Ekl. All rights reserved.
//

import UIKit
import WebKit

class BulletinNavigationController: UINavigationController {
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        setUpBulletinManager()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpBulletinManager()
    }
    
    private func setUpBulletinManager() {
        let manager = BulletinManager.shared
        
        NotificationCenter.default.addObserver(self, selector: #selector(bulletinDidChange(_:)), name: BulletinManager.bulletinDidChangeNotification, object: manager)
        NotificationCenter.default.addObserver(self, selector: #selector(bulletinDidChange(_:)), name: BulletinManager.lastSeenDateDidChangeNotification, object: manager)
        
        do {
            try manager.loadCachedBulletin()
        } catch {
            // TODO: error handling? os_log?
        }
        manager.requestServerBulletin()
    }
    
    @objc dynamic private func bulletinDidChange(_ notification: Notification) {
        guard let bulletinManager = notification.object as? BulletinManager else { return }
        if let bulletin = bulletinManager.latestBulletin, !bulletinManager.hasSeenBulletin(at: bulletin.metadata.published) {
            tabBarItem.badgeValue = "•"
        } else {
            tabBarItem.badgeValue = nil
        }
    }
}

class BulletinViewController: UIViewController {
    
    @IBOutlet private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bulletinManager = BulletinManager.shared
        if let bulletin = bulletinManager.latestBulletin {
            bulletinManager.loadContents(of: bulletin) { (data, error) in
                if let error = error {
                    assertionFailure("Error loading bulletin: \(error)")
                    fatalError("This needs better error handling!")
                }
                
                guard let data = data else {
                    assertionFailure("Received neither data nor error.")
                    return
                }
                
                // TODO: don't hardcode 'text/html'?
                webView.load(data, mimeType: "text/html", characterEncodingName: "utf-8", baseURL: bulletin.sourceURL)
                
                bulletinManager.setLastSeenBulletin(bulletin)
            }
        }
    }
    
}
