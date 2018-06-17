//
//  MainViewModel.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/13/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

import RxSwift
import SwiftyJSON

final class MainViewModel: BaseViewModel {

    private let pageSize = 10
    private var currentIndex: Int = 0
    private var topFreeAppModel: Feed?

    var sGotTopFreeApp = PublishSubject<Void>()
    var entries = Array<Entry>()

    override init() {
        super.init()
        // bind API
        APIManager.shared.sIsLoadingTopFreeApp
            .subscribe(onNext: onIsLoading)
            .disposed(by: disposeBag)

        APIManager.shared.sErrorGetTopFreeApp
            .subscribe(onNext: onError)
            .disposed(by: disposeBag)

        APIManager.shared.sGotTopFreeApp
            .subscribe(onNext: onGotTopFreeApp)
            .disposed(by: disposeBag)

        APIManager.shared.sIsLoadingLookup
            .subscribe(onNext: onIsLoading)
            .disposed(by: disposeBag)

        APIManager.shared.sErrorGetLookup
            .subscribe(onNext: onError)
            .disposed(by: disposeBag)

        APIManager.shared.sGotLookup
            .subscribe(onNext: onGotLookup)
            .disposed(by: disposeBag)
    }

    private func onGotTopFreeApp(feed: Feed) {
        topFreeAppModel = feed
        getNextLookup()
    }

    private func getAppIds(at: Int) -> String {
        var ids = [String]()
        for i in stride(from: at, to: at + pageSize, by: 1) {
            if let appId = topFreeAppModel?.entries?[i].appId {
                ids.append(appId)
            }
        }
        return ids.joined(separator: ",")
    }

    private func onGotLookup(json: JSON) {
        // merge lookup result to loaded list
        if let results = json["results"].array {
            var index = 0
            for i in stride(from: currentIndex, to: currentIndex + pageSize, by: 1) {
                if var entry = topFreeAppModel?.entries?[i] {
                    entry.averageUserRating = CGFloat(results[index]["averageUserRating"].floatValue)
                    entry.userRatingCount = results[index]["userRatingCount"].intValue
                    entries.append(entry)
                }
                index += 1
            }
            // update current index
            currentIndex += pageSize
            sGotTopFreeApp.onNext(())
        }
    }

    func fetchData() {
        APIManager.shared.getTopFreeApp()
    }

    func fetchDataIfNeed(at: Int) {
        if at >= currentIndex - 1 {
            getNextLookup()
        }
    }

    func getNextLookup() {
        if let total = topFreeAppModel?.getEntiesCount(), currentIndex + pageSize <= total {
            APIManager.shared.getLookup(getAppIds(at: currentIndex))
        }
    }

    func getTopFreeAppCount() -> Int {
        return entries.count
    }

}
