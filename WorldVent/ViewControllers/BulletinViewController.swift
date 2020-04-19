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
    
}
