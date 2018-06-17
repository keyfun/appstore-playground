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
    private var currentIndex = 0
    private var topFreeAppModel: Feed?

    var sGotTopFreeApp = PublishSubject<Void>()
    private var entries = Array<Entry>()
    private var isLoadingLookup = false
    private var filterEntries = Array<Entry>() // for search result
    private var isSearchResult = false

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
            .subscribe(onNext: onIsLoadingLookup)
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
                    let target = results[index]
                    let targetAppId = target["trackId"].stringValue
                    // double verify is same appId
                    if entry.appId == targetAppId {
                        entry.averageUserRating = CGFloat(target["averageUserRating"].floatValue)
                        entry.userRatingCount = target["userRatingCount"].intValue
                        entries.append(entry)
                    }
                }
                index += 1
            }
            // update current index
            currentIndex += pageSize
            sGotTopFreeApp.onNext(())
        }
    }

    private func onIsLoadingLookup(value: Bool) {
        isLoadingLookup = value
    }

    func fetchData() {
        if NetworkManager.shared.hasNetwork() {
            APIManager.shared.getTopFreeApp()
        } else {
            // TODO: show retry method
        }
    }

    func fetchDataIfNeed(at: Int) {
        if at >= currentIndex - 1 {
            getNextLookup()
        }
    }

    func getNextLookup() {
        if !isLoadingLookup {
            if let total = topFreeAppModel?.getEntiesCount(), currentIndex + pageSize <= total {
                APIManager.shared.getLookup(getAppIds(at: currentIndex))
            }
        }
    }

    func getEntriesCount() -> Int {
        return isSearchResult ? filterEntries.count : entries.count
    }

    func getEntries() -> Array<Entry> {
        return isSearchResult ? filterEntries : entries
    }

    func getEntry(index: Int) -> Entry {
        if isSearchResult {
            if index < filterEntries.count {
                return filterEntries[index]
            }
        } else {
            if index < entries.count {
                return entries[index]
            }
        }
        return Entry()
    }

    func search(_ searchText: String) {
        isSearchResult = !searchText.isEmpty

        filterEntries = entries.filter { (entry) -> Bool in
            if let name = entry.name {
                return name.lowercased().contains(searchText.lowercased())
            }
            return false
        }
    }

}
