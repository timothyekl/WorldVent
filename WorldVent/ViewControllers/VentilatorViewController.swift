//
//  VentilatorViewController.swift
//  WorldVent
//
//  Created by Timothy Ekl on 4/12/20.
//  Copyright © 2020 Tim Ekl. All rights reserved.
//

import UIKit
import WebKit

class VentilatorViewController: SearchableWebViewController {
    override var initialFilePath: String {
        return "doc/index.html"
    }
    
    override var searchBasePath: String {
        return "doc"
    }
}
