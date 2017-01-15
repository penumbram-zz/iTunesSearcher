//
//  SearchViewController.swift
//  iTunesSearcher
//
//  Created by Tolga Caner on 15/01/17.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    
    weak var resultsViewController: ResultsViewController!
    var searchController : UISearchController!
    
    var currentFilter : String?
    var latestSearchText : String?
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchController = UISearchController(searchResultsController:  nil)
        self.searchController.searchResultsUpdater = self
        self.searchController.delegate = self
        self.searchController.searchBar.delegate = self
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = true
        self.navigationItem.titleView = searchController.searchBar
        self.definesPresentationContext = true
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icnFilter"), style: .plain, target: self, action: #selector(SearchViewController.filterAction))
        self.resultsViewController = self.childViewControllers[0] as! ResultsViewController
    }
    
    func filterAction() {
        if let filterViewController = self.storyboard?.instantiateViewController(withIdentifier: "filterViewControllerId") as? FilterViewController {
            if currentFilter != nil {
                filterViewController.selectedFilter = currentFilter!.copy() as? String
            }
            filterViewController.modalTransitionStyle = .coverVertical
            self.present(filterViewController, animated: true, completion: nil)
            
        }
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, searchText.characters.count > 0 else {
            return
        }
        search(text: searchText)
    }
    
    func search(text : String?) {
        var text = text
        if text == nil && self.latestSearchText != nil {
            text = self.latestSearchText!
        }
        
        guard text != nil else {
            return
        }
        networkManager.search(text: text!,filter : self.currentFilter, completion: {(results: NSArray) in
            networkManager.cache = NSCache()
            self.resultsViewController.reload(data: results, filter: self.currentFilter)
            DispatchQueue.main.async {
                self.searchController.isActive = false
                self.resultsViewController.tableView.fadeIn()
            }
        })
        self.latestSearchText = text
    }
    
    func promptReload() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let alertController = UIAlertController(title: "", message: "Would you like to reload the results for \"\(self.latestSearchText!)\" with the new filters?", preferredStyle: .alert)
            
            let actionNo = UIAlertAction(title: "No", style: .default, handler: nil)
            let actionYes = UIAlertAction(title: "Yes", style: .default, handler: {(alert: UIAlertAction!) in self.search(text: nil)})
            alertController.addAction(actionNo)
            alertController.addAction(actionYes)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
}
