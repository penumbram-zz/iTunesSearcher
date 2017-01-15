//
//  UIViewExtensions.swift
//  iTunesSearcher
//
//  Created by Tolga Caner on 15/01/17.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import UIKit

extension UIView {
    func fadeIn() {
        guard self.alpha != 0 else {
            UIView.animate(withDuration: 0.33, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.alpha = 1.0
            }, completion: nil)
            return
        }
        
    }
    
    func fadeOut() {
        guard self.alpha == 0 else {
            UIView.animate(withDuration: 0.50, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.alpha = 0.0
            }, completion: nil)
            return
        }
    }
    
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    class func loadFrom(nibName: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibName,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}
