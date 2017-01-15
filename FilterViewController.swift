//
//  FilterViewController.swift
//  iTunesSearcher
//
//  Created by Tolga Caner on 15/01/17.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import UIKit
let all = "All"

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let dataSource = [all,"Movie","Podcast","Music","Music Video","Audiobook","Short Film","TV Show","Software","E-book"]
    var selectedFilter : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedFilter == nil {
            selectedFilter = all
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "filterCellIdentifier")
        let filterText = dataSource[indexPath.row]
        cell.textLabel?.text = filterText
        cell.selectedBackgroundView = clearView
        cell.tintColor = .black
        if selectedFilter == filterText {
            cell.accessoryType = .checkmark
            self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
            self.tableView(tableView, didSelectRowAt: indexPath)
        } else {
            cell.accessoryType = .none
            self.tableView.deselectRow(at: indexPath, animated: false)
            self.tableView(tableView, didDeselectRowAt: indexPath)
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            
            cell.accessoryType = .checkmark
            let filterText = cell.textLabel!.text!
            self.selectedFilter = filterText
            self.tableView.beginUpdates()
            self.tableView.reloadSections(IndexSet(integer:0), with: .automatic)
            self.tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
            if cell.textLabel?.text == selectedFilter {
                self.selectedFilter = nil
            }
        }
    }
    
    @IBAction func btnBackAction(_ sender: UIButton) {
        if let searchViewController = self.presentingViewController?.childViewControllers[0] as? SearchViewController {
            if searchViewController.currentFilter != self.selectedFilter {
                searchViewController.currentFilter = self.selectedFilter?.copy() as? String
                if searchViewController.latestSearchText != nil {
                    searchViewController.promptReload()
                }
            }
            
        }
        self.dismiss(animated: true, completion: nil)
    }
}
