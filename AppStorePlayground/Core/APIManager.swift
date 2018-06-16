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

    private let kTopGrossingAppUrl = "https://itunes.apple.com/hk/rss/topgrossingapplications/limit=10/json"
    private let kTopFreeAppUrl = "https://itunes.apple.com/hk/rss/topfreeapplications/limit=10/json"
    private let kLookupUrl = "https://itunes.apple.com/hk/lookup?id=%@"

    var sIsLoadingTopGrossingApp = PublishSubject<Bool>()
    var sErrorGetTopGrossingApp = PublishSubject<Error>()
    var sGotTopGrossingApp = PublishSubject<Feed>()

    var sIsLoadingTopFreeApp = PublishSubject<Bool>()
    var sErrorGetTopFreeApp = PublishSubject<Error>()
    var sGotTopFreeApp = PublishSubject<Feed>()

    func getTopGrossingApp() {
        _ = json(.get, kTopGrossingAppUrl)
            .observeOn(MainScheduler.instance)
            .do(onNext: { (result) in
                self.sGotTopGrossingApp.onNext(Feed(JSON(result)))
            }, onError: { (error) in
                    print(error)
                    self.sIsLoadingTopGrossingApp.onNext(false)
                    self.sErrorGetTopGrossingApp.onNext(error)
                }, onCompleted: {
                    self.sIsLoadingTopGrossingApp.onNext(false)
                }, onSubscribe: {
                    self.sIsLoadingTopGrossingApp.onNext(true)
                })
            .subscribe()
    }

    func getTopFreeApp() {
        var feed = Feed()
        _ = json(.get, kTopFreeAppUrl)
            .observeOn(MainScheduler.instance)
            .flatMapLatest({ (result) -> Observable<Any> in
                feed = Feed(JSON(result))

                var appId = ""
                feed.entries?.forEach({ (entry) in
                    appId += entry.appId! + ","
                })

                let url = String.init(format: self.kLookupUrl, appId)
                print(url)
                return json(.get, url)
            })
            .do(onNext: { (response) in
                let json = JSON(response)
                if let results = json["results"].array, let entries = feed.entries {
                    for (index, _) in entries.enumerated() {
                        feed.entries?[index].averageUserRating = CGFloat(results[index]["averageUserRating"].floatValue)
                        feed.entries?[index].userRatingCount = results[index]["userRatingCount"].intValue
                    }
                }
                self.sGotTopFreeApp.onNext(feed)
            }, onError: { (error) in
                    print(error)
                    self.sIsLoadingTopFreeApp.onNext(false)
                    self.sErrorGetTopFreeApp.onNext(error)
                }, onCompleted: {
                    self.sIsLoadingTopFreeApp.onNext(false)
                }, onSubscribe: {
                    self.sIsLoadingTopFreeApp.onNext(true)
                })
            .subscribe()
    }

    func getLookup(_ appId: String) {
        let url = String.init(format: kLookupUrl, appId)
        print(url)
        _ = json(.get, url)
            .observeOn(MainScheduler.instance)
            .subscribe { print($0) }
    }
}
