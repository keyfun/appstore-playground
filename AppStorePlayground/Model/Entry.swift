//
//  Entry.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/16/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

import SwiftyJSON

struct Entry {
    var name: String?
    var image: String? // [53, 75, 100] height
    var summary: String?
    var price: String?
    var contentType: String?
    var title: String?
    var link: String?
    // id
    var id: String?
    var appId: String?
    var bundleId: String?
    var category: String?
    var releaseDate: String?

    init(_ json: JSON) {
        name = json["im:name"]["label"].stringValue
        image = json["im:image"][2]["label"].stringValue
        summary = json["summary"]["label"].stringValue
        category = json["category"]["attributes"]["label"].stringValue
        title = json["title"]["label"].stringValue
    }

    func toString() -> String {
        let format = "name = %@,\nimage = %@,\nsummary = %@,\ncategory = %@,\ntitle = %@"
        let str = String(format: format,
            name ?? "",
            image ?? "",
            summary ?? "",
            category ?? "",
            title ?? "")
        return str
    }
}
