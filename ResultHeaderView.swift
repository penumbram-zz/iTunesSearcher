//
//  ResultHeaderView.swift
//  iTunesSearcher
//
//  Created by Tolga Caner on 15/01/17.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import UIKit

protocol ClearFilterDelegate: class {
    func clearFilters()
}

class ResultHeaderView: UIView {
    
    weak var delegate:ClearFilterDelegate?
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBAction func actionClearFilters(_ sender: UIButton) {
        delegate?.clearFilters()
    }
}
