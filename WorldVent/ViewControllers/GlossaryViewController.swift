//
//  GlossaryViewController.swift
//  WorldVent
//
//  Created by Timothy Ekl on 4/14/20.
//  Copyright © 2020 Tim Ekl. All rights reserved.
//

import UIKit
import WebKit

class GlossaryViewController: SearchableWebViewController {
    override var initialFilePath: String {
        return "index.html"
    }
    
    override var searchBasePath: String {
        return ""
    }
}
