//
//  SettingsViewController.swift
//  WorldVent
//
//  Created by Timothy Ekl on 4/12/20.
//  Copyright © 2020 Tim Ekl. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet var versionNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        versionNumberLabel.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
}
