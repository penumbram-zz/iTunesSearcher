//
//  StringExtensions.swift
//  iTunesSearcher
//
//  Created by Tolga Caner on 15/01/17.
//  Copyright © 2017 Tolga Caner. All rights reserved.
//

import Foundation

extension String {
    var camelcaseString: String {
        let source = self
        if source.characters.contains(" ") {
            let first = source.substring(to: source.characters.index(source.startIndex, offsetBy: 1))
            let camel = source.capitalized.replacingOccurrences(of: " " , with: "")
            let rest = String(camel.characters.dropFirst())
            return "\(first)\(rest)"
        } else {
            return source
        }
    }
}
