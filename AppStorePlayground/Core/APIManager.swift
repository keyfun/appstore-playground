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
        _ = json(.get, kTopFreeAppUrl)
            .observeOn(MainScheduler.instance)
            .subscribe {
                if let element = $0.element {
                    RepositoryManager.shared.topFreeAppModel = Feed(JSON(element))
                }
        }
    }

    func getLookup(_ appId: String) {
        let url = String.init(format: kLookupUrl, appId)
        print(url)
        _ = json(.get, url)
            .observeOn(MainScheduler.instance)
            .subscribe { print($0) }
    }
}
