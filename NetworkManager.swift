//
//  NetworkManager.swift
//  iTunesSearcher
//
//  Created by Tolga Caner on 15/01/17.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import UIKit

class NetworkManager {
    
    let endPoint = "https://itunes.apple.com/search?"
    let session = URLSession(configuration: URLSessionConfiguration.default)
    var cache:NSCache<AnyObject, AnyObject>!
    
    func search(text : String, filter: String?, completion:@escaping (_: NSArray) -> Void) {
        
        let url = searchUrlFromEndPoint(term: text,filter: filter)
        print(url)
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    {
                        if let resultsArray = json["results"] as? NSArray {
                            completion(resultsArray)
                        }
                    }
                } catch {
                    print("error in JSONSerialization")
                }
            }
        })
        task.resume()
    }
    
    func downloadImage(urlString : String, completion:@escaping (_ image : UIImage) -> Void) {
        
        
        
        let url = URL(string: urlString)!
        let task = session.downloadTask(with: url, completionHandler: { (location: URL?, response: URLResponse?, error: Error?) -> Void in
            
            if location != nil{
                let imageData:Data! = try? Data(contentsOf: location!)
                let image = UIImage(data:imageData,scale:1.0)
                completion(image!)
            }
        })
        task.resume()
    }
    
    func searchUrlFromEndPoint(term : String,filter : String?) -> URL {
        var filterString = ""
        if filter != nil {
            filterString = "&media=" + filter!.lowercased().replacingOccurrences(of: "-", with: "").camelcaseString
        }
        return URL(string: endPoint + "term=\(term)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)! + "&limit=200" + filterString)!
    }
}
