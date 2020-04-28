//
//  VentilatorViewController.swift
//  WorldVent
//
//  Created by Timothy Ekl on 4/12/20.
//  Copyright © 2020 Tim Ekl. All rights reserved.
//

import UIKit
import WebKit

class VentilatorViewController: UIViewController {
    @IBOutlet var webView: WKWebView!

    var searchController: UISearchController!

  
    override func viewDidLoad() {
        super.viewDidLoad()
        let f=HTFile(path:"doc/index.html");
        self.webView.loadHTMLString(f.html, baseURL: f.url);
        

    }

}

