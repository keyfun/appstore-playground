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
    private let kTopFreeAppUrl = "https://itunes.apple.com/hk/rss/topfreeapplications/limit=100/json"
    private let kLookupUrl = "https://itunes.apple.com/hk/lookup?id=%@"

    var sIsLoadingTopGrossingApp = PublishSubject<Bool>()
    var sErrorGetTopGrossingApp = PublishSubject<Error>()
    var sGotTopGrossingApp = PublishSubject<Feed>()

    var sIsLoadingTopFreeApp = PublishSubject<Bool>()
    var sErrorGetTopFreeApp = PublishSubject<Error>()
    var sGotTopFreeApp = PublishSubject<Feed>()

    var sIsLoadingLookup = PublishSubject<Bool>()
    var sErrorGetLookup = PublishSubject<Error>()
    var sGotLookup = PublishSubject<JSON>()

    func getTopGrossingApp() {
        _ = json(.get, kTopGrossingAppUrl)
            .observeOn(MainScheduler.instance)
            .do(onNext: { (result) in
                let json = JSON(result)
                RepositoryManager.shared.saveTopGrossingAppJson(json)
                self.sGotTopGrossingApp.onNext(Feed(json))
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

    // get all data with lookup
    func getTopFreeAppWithLookup() {
        var feed = Feed()
        _ = json(.get, kTopFreeAppUrl)
            .observeOn(MainScheduler.instance)
            .flatMap({ (result) -> Observable<Any> in
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

    func getTopFreeApp() {
        _ = json(.get, kTopFreeAppUrl)
            .observeOn(MainScheduler.instance)
            .do(onNext: { (result) in
                let json = JSON(result)
                RepositoryManager.shared.saveTopFreeAppJson(json)
                self.sGotTopFreeApp.onNext(Feed(json))
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

    // for pagination
    func getLookup(_ appId: String) {
        let url = String.init(format: kLookupUrl, appId)
        print(url)
        _ = json(.get, url)
            .observeOn(MainScheduler.instance)
            .do(onNext: { (result) in
                self.sGotLookup.onNext(JSON(result))
            }, onError: { (error) in
                    print(error)
                    self.sIsLoadingLookup.onNext(false)
                    self.sErrorGetLookup.onNext(error)
                }, onCompleted: {
                    self.sIsLoadingLookup.onNext(false)
                }, onSubscribe: {
                    self.sIsLoadingLookup.onNext(true)
                })
            .subscribe()
    }
}
