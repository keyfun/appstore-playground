//
//  APIManager.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/13/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

import RxAlamofire
import RxSwift
import SwiftyJSON

final class APIManager {

    static let shared = APIManager()

    private let kTopFreeAppUrl = "https://itunes.apple.com/hk/rss/topfreeapplications/limit=100/json"
    private let kLookupUrl = "https://itunes.apple.com/hk/lookup?id=%@"
    private let kTopGrossingAppUrl = "https://itunes.apple.com/hk/rss/topgrossingapplications/limit=10/json"

    func getTopFreeApp() {
        _ = json(.get, kTopFreeAppUrl)
            .observeOn(MainScheduler.instance)
            .subscribe {
                if let element = $0.element {
                    let feed = Feed(JSON(element))
                    print(feed.toString())
                    feed.printEntries()
                }
        }
    }

    func getLookup(_ appId: String) {
        let url = String.init(format: kLookupUrl, appId)
        debugPrint(url)
        _ = json(.get, url)
            .observeOn(MainScheduler.instance)
            .subscribe { print($0) }
    }

    func getTopGrossingApp() {
        _ = json(.get, kTopGrossingAppUrl)
            .observeOn(MainScheduler.instance)
            .subscribe { print($0) }
    }
}
