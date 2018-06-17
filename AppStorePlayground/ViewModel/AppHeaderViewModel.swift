//
//  AppHeaderViewModel.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/17/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

import RxSwift

final class AppHeaderViewModel: BaseViewModel {

    var sGotTopGrossingApp = PublishSubject<Void>()
    private var topGrossingAppModel: Feed?
    private var entries = Array<Entry>()
    private var filterEntries = Array<Entry>()
    private var isSearchResult = false

    override init() {
        super.init()
        // bind API
        APIManager.shared.sIsLoadingTopGrossingApp
            .subscribe(onNext: onIsLoading)
            .disposed(by: disposeBag)

        APIManager.shared.sErrorGetTopGrossingApp
            .subscribe(onNext: onError)
            .disposed(by: disposeBag)

        APIManager.shared.sGotTopGrossingApp
            .subscribe(onNext: onGotTopGrossingApp)
            .disposed(by: disposeBag)
    }
    
    private func onGotTopGrossingApp(feed: Feed) {
        topGrossingAppModel = feed
        if let entries = feed.entries {
            self.entries = entries
        }
        sGotTopGrossingApp.onNext(())
    }

    func fetchData() {
        if NetworkManager.shared.hasNetwork() {
            APIManager.shared.getTopGrossingApp()
        } else {
            // TODO: show retry method
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
