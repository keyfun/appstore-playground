//
//  Feed.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/16/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

import SwiftyJSON

struct Feed {
    
    var authorName: String?
    var updated: String?
    var title: String?
    var entries: Array<Entry>?
    
    init() {
    }
    
    init(_ json: JSON) {
        setData(json)
    }
    
    mutating func setData(_ json: JSON) {
        let feed = json["feed"]
        authorName = feed["author"]["name"]["label"].stringValue
        updated = feed["updated"]["label"].stringValue
        title = feed["title"]["label"].stringValue
        
        entries = feed["entry"].array?.map({ (item) -> Entry in
            return Entry(item)
        })
    }

    func toString() -> String {
        let format = "authorName = %@,\nupdated = %@,\ntitle = %@\nentryCount = %d"
        let str = String(format: format,
            authorName ?? "",
            updated ?? "",
            title ?? "",
            entries?.count ?? 0)
        return str
    }
    
    func printEntries() {
        entries?.forEach({ (entry) in
            print(entry.toString())
        })
    }
}
