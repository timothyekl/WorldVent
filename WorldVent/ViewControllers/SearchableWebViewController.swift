//
//  SearchableWebViewController.swift
//  WorldVent
//
//  Created by Timothy Ekl on 4/28/20.
//  Copyright © 2020 Tim Ekl. All rights reserved.
//

import UIKit

import WebKit

/// A single instance of a search result inside HTML content.
fileprivate struct WebSearchResult {
    /// The phrase that is (or surrounds) a match for a search string.
    var matchPhrase: String
    /// Additional contextual information about the search result (e.g. the file path or enclosing section name).
    var detailText: String
    /// A relative path to the HTML document that contains the match.
    var resultFilePath: String
}

fileprivate class WebSearchResultTableViewCell: UITableViewCell {
    var result: WebSearchResult? = nil {
        didSet {
            textLabel?.text = result?.matchPhrase
            detailTextLabel?.text = result?.detailText
        }
    }
}

fileprivate protocol WebSearchResultsViewControllerDelegate: AnyObject {
    func webSearchResultsViewController(_ controller: WebSearchResultsViewController, didSelectSearchResult searchResult: WebSearchResult)
}

fileprivate class WebSearchResultsViewController: UITableViewController {
    
    fileprivate weak var delegate: WebSearchResultsViewControllerDelegate?
    
    /// Create a new search results table view controller that searches the given path, which is expected to represent a directory containing searchable HTML content.
    init(basePath: String) {
        self.basePath = basePath
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// The current search string. Setting this value will incur the work of searching the HTML content in the base path.
    var searchString: String? = nil {
        didSet {
            guard let searchString = searchString else {
                searchResults = []
                return
            }
            searchResults = searchContent(for: searchString)
        }
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(WebSearchResultTableViewCell.self, forCellReuseIdentifier: "result")
    }
    
    // MARK: UITableViewDataSource & UITableViewDelegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "result", for: indexPath) as! WebSearchResultTableViewCell
        cell.result = searchResults[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let result = searchResults[indexPath.row]
        delegate?.webSearchResultsViewController(self, didSelectSearchResult: result)
    }
    
    // MARK: Private
    
    private var basePath: String
    
    private var searchResults: [WebSearchResult] = [] {
        didSet {
            guard isViewLoaded else { return }
            tableView.reloadData()
        }
    }
    
    private func searchContent(for searchString: String) -> [WebSearchResult] {
        // TODO: This is the part that needs implementing. Search the HTML content at the `basePath` and return `WebSearchResult` instances.
        let placeholderResult = WebSearchResult(matchPhrase: "Example match", detailText: "index.html", resultFilePath: (basePath as NSString).appendingPathComponent("index.html"))
        return [placeholderResult]
    }
}

// MARK: -

/// SearchableWebViewController is an abstract superclass view controller that provides a WKWebView for viewing some HTML content, as well as a search interface.
/// It exposes a few pieces of API that concrete subclasses are required to override for correct functionality; see the "Subclass API" mark below.
class SearchableWebViewController: UIViewController {
    
    @IBOutlet var webView: WKWebView!
    
    private var searchController: UISearchController!
    private var resultsController: WebSearchResultsViewController {
        return searchController.searchResultsController as! WebSearchResultsViewController
    }
    
    // MARK: Subclass API
    
    open var initialFilePath: String {
        fatalError("SearchableWebViewController.initialFilePath is required to be implemented by subclasses.")
    }
    
    open var searchBasePath: String {
        fatalError("SearchableWebViewController.searchBasePath is required to be implemented by subclasses.")
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the initial background color right away
        if #available(iOS 13.0, *) {
            webView.backgroundColor = .systemBackground
        } else {
            webView.backgroundColor = .white
        }
        
        // Configure the search controller & navigation item
        let resultsController = WebSearchResultsViewController(basePath: searchBasePath)
        resultsController.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.dimsBackgroundDuringPresentation = false
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        
        // Finish by loading HTML
        // This can take some time, since it may require extensive parsing, and we're on the main thread
        // Do this last in viewDidLoad() so we're not blocking configuration of the chrome around this content
        let f = HTFile(path: initialFilePath)
        self.webView.loadHTMLString(f.html, baseURL: f.url)
    }
}

extension SearchableWebViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        resultsController.searchString = searchController.searchBar.text
    }

}

extension SearchableWebViewController: WebSearchResultsViewControllerDelegate {
    fileprivate func webSearchResultsViewController(_ controller: WebSearchResultsViewController, didSelectSearchResult searchResult: WebSearchResult) {
        searchController.isActive = false
        // TODO: navigate the web view to the page indicated by searchResult.resultFilePath
    }
}
