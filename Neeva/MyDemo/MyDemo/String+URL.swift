//
//  String+URL.swift
//  MyDemo
//
//  Created by Shinan Liu on 4/9/21.
//

import Foundation


extension String {
    func isURL() -> Bool {
        if self.hasPrefix("https://") || self.hasPrefix("http://") {
            return true
        }
        
        return self.range(of: "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$", options: .regularExpression) != nil
    }
}
