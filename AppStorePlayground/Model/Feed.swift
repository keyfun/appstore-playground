//
//  Feed.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/16/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

import SwiftyJSON

struct Feed {
    var authorName: String = ""
    var updated: String = ""
    var title: String = ""

    init(_ json: JSON) {
        authorName = json["feed"]["author"]["name"]["label"].stringValue
    }

    func toString() -> String {
        return "authorName = \(authorName)"
    }
}
