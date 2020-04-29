//
//  VentilatorViewController.swift
//  WorldVent
//
//  Created by Timothy Ekl on 4/12/20.
//  Copyright © 2020 Tim Ekl. All rights reserved.
//

import UIKit
import WebKit

class VentilatorViewController: UIViewController,UISearchResultsUpdating,UISearchBarDelegate {
    @IBOutlet var webView: WKWebView!

    var searchController: UISearchController!

  
    override func viewDidLoad() {
        super.viewDidLoad()
        let f=HTFile(path:"doc/index.html")
        self.webView.loadHTMLString(f.html, baseURL: f.url)


        searchController = UISearchController(searchResultsController: nil)
        // searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self // Monitor when the search button is tapped.

        // Place the search bar in the navigation bar.
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling =  false

    }
    
    func updateSearchResults(for searchController: UISearchController) {    // called when query has changed
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {   // called when the button is pressed

    }

}

