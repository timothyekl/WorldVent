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
        registerObservers()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        registerObservers()
    }
    
    private func registerObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(bulletinDidChange(_:)), name: BulletinManager.bulletinDidChangeNotification, object: BulletinManager.shared)
    }
    
    @objc dynamic private func bulletinDidChange(_ notification: Notification) {
        guard let bulletinManager = notification.object as? BulletinManager else { return }
        if let _ = bulletinManager.latestBulletin {
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
        
        if let bulletin = BulletinManager.shared.latestBulletin {
            bulletin.loadContents { (data, error) in
                if let error = error {
                    assertionFailure("Error loading bulletin: \(error)")
                    fatalError("This needs better error handling!")
                }
                
                guard let data = data else {
                    assertionFailure("Received neither data nor error.")
                    return
                }
                
                // TODO: don't hardcode 'text/html'?
                webView.load(data, mimeType: "text/html", characterEncodingName: "utf-8", baseURL: bulletin.url)
            }
        }
    }
    
}
