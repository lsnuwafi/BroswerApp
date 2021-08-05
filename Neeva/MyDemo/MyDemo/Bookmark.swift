//
//  Bookmark.swift
//  MyDemo
//
//  Created by Shinan Liu on 4/11/21.
//

import Foundation
class Bookmark: NSObject, NSCoding, NSSecureCoding {
    static var supportsSecureCoding: Bool = true
    
    func encode(with coder: NSCoder) {
        coder.encode(name, forKey: "name")
        coder.encode(pageURL, forKey: "url")
    }
    
    required convenience init?(coder: NSCoder) {
        let name = coder.decodeObject(forKey: "name") as! String
        let pageURL = coder.decodeObject(forKey: "url") as! String
        self.init(name, pageURL)
    }
    

    var name = ""
    var pageURL = ""
    init(_ name: String, _ pageURL: String) {
        self.name = name
        self.pageURL = pageURL
    }
}
