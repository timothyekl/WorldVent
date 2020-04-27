//
//  GlossaryViewController.swift
//  WorldVent
//
//  Created by Timothy Ekl on 4/14/20.
//  Copyright © 2020 Tim Ekl. All rights reserved.
//

import UIKit
import WebKit

class GlossaryViewController: UIViewController {
    @IBOutlet var webView: WKWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let f=HTFile(path:"index.html");
        self.webView.loadHTMLString(f.html, baseURL: f.url);
    }
}
