//
//  ItemDetailViewController.swift
//  iTunesSearcher
//
//  Created by Tolga Caner on 15/01/17.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import UIKit

class ItemDetailViewController : UIViewController {
    var model : NSDictionary!
    @IBOutlet weak var ivMain: UIImageView!
    
    @IBOutlet weak var lbl1: UILabel!
    
    @IBOutlet weak var lbl2: UILabel!
    
    @IBOutlet weak var lbl3: UILabel!
    
    @IBOutlet weak var btnPreview: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let urlString = model.object(forKey: "artworkUrl100") as! String
        networkManager.downloadImage(urlString: urlString, completion: {image in
            self.ivMain.image = image
        })
        lbl1.text = model.object(forKey: "artistName") as? String
        lbl2.text = model.object(forKey: "collectionName") as? String
        lbl3.text = model.object(forKey: "trackName") as? String
        guard (model.object(forKey: "previewUrl") as? String) != nil else {
            self.btnPreview.isHidden = true
            return
        }
    }
    
    @IBAction func btnPreviewAction(_ sender: UIButton) {
        let previewUrl = model.object(forKey: "previewUrl") as? String
        if (previewUrl != nil) {
            UIApplication.shared.openURL(URL(string: previewUrl!)!)
        }
    }
    
    
    
}
