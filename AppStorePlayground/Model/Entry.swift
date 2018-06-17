//
//  Entry.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/16/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

import SwiftyJSON

struct Entry {
    var order: Int?
    var name: String?
    var image53: String? // height 53
    var image75: String? // height 75
    var image100: String? // height 100
    var contentType: String?
    var title: String?
    var link: String?
    // id
    var appId: String?
    var bundleId: String?
    var category: String?
    var releaseDate: String?
    var averageUserRating: CGFloat?
    var userRatingCount: Int?
    
    // for UI Animation
    var isLoaded = false

    init() {
    }
    
    init(_ json: JSON, order: Int? = nil) {
        setData(json)
        self.order = order
    }
    
    mutating func setData(_ json: JSON) {
        name = json["im:name"]["label"].stringValue
        image53 = json["im:image"][0]["label"].stringValue
        image75 = json["im:image"][1]["label"].stringValue
        image100 = json["im:image"][2]["label"].stringValue
        category = json["category"]["attributes"]["label"].stringValue
        contentType = json["im:contentType"]["attributes"]["label"].stringValue
        title = json["title"]["label"].stringValue
        link = json["link"]["attributes"]["href"].stringValue
        appId = json["id"]["attributes"]["im:id"].stringValue
        bundleId = json["id"]["attributes"]["im:bundleId"].stringValue
    }

    func toString() -> String {
        let format = "name = %@,\nimage53 = %@,\ncategory = %@,\ntitle = %@"
        let str = String(format: format,
            name ?? "",
            image53 ?? "",
            category ?? "",
            title ?? "")
        return str
    }
}
