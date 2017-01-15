//
//  ResultsViewController.swift
//  iTunesSearcher
//
//  Created by Tolga Caner on 15/01/17.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import UIKit

class ResultsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate,ClearFilterDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var vNoResults: UIView!
    var dataSource = NSArray()
    var filter : String?
    let cellReuseIdentifier = "resultCellReuseId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func reload(data : NSArray, filter : String?) {
        self.dataSource = data
        self.filter = filter
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(integer: 0), with: UITableViewRowAnimation.automatic)
            if self.dataSource.count == 0 {
                self.tableView.fadeOut()
                self.vNoResults.fadeIn()
            } else {
                self.tableView.fadeIn()
                self.vNoResults.fadeOut()
            }
        }
        
    }
    
    func clearFilters() {
        if let searchViewController = self.parent as? SearchViewController {
            searchViewController.currentFilter = nil
            searchViewController.search(text: nil)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? ResultsTableViewCell
        if (cell == nil)
        {
            cell = ResultsTableViewCell(style: .default, reuseIdentifier: cellReuseIdentifier)
        }
        cell?.selectedBackgroundView = clearView
        var title = ""
        var artist = ""
        var imageUrl : String!
        if let model = self.dataSource.object(at: indexPath.row) as? NSDictionary {
            cell?.model = model
            if let trackName = model.object(forKey: "trackName") as? String {
                title = trackName
            }
            if let artistName = model.object(forKey: "artistName") as? String {
                artist = artistName
            }
            if let url = model.object(forKey: "artworkUrl60") as? String {
                imageUrl = url
            }
        }
        cell?.ivMain.image = nil
        if (networkManager.cache.object(forKey:indexPath.row as AnyObject) != nil){
            
            cell!.ivMain.image = networkManager.cache.object(forKey: indexPath.row as AnyObject) as? UIImage
        } else {
            networkManager.downloadImage(urlString: imageUrl, completion: {image in
                DispatchQueue.main.async {
                cell!.ivMain.image = image
                networkManager.cache.setObject(image, forKey:indexPath.row as AnyObject)
                }
            })
        }
        
        cell!.lblTitle.text = title
        cell!.lblDescription.text = artist
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.filter == nil || self.filter == all {
            return 0.0
        }
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.filter != nil {
            if self.filter != nil && self.filter != all {
                let resultHeaderView = UIView.loadFrom(nibName: "ResultHeaderView") as! ResultHeaderView
                resultHeaderView.delegate = self
                resultHeaderView.lblTitle.text = "Filtered by: " + self.filter!
                return resultHeaderView
            }
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = self.tableView(tableView, cellForRowAt: indexPath) as? ResultsTableViewCell {
            
            if let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "itemDetailViewController") as? ItemDetailViewController {
                detailViewController.model = cell.model
                self.navigationController?.pushViewController(detailViewController, animated: true)
                
            }
        }
    }
}
