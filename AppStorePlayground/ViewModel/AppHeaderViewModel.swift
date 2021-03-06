//
//  AppHeaderViewModel.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/17/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

import RxSwift

final class AppHeaderViewModel: SearchViewModel {

    var sGotTopGrossingApp = PublishSubject<Void>()
    private var topGrossingAppModel: Feed?

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
            // get local cache if no network and has cache
            if RepositoryManager.shared.topGrossingAppModel.getEntiesCount() > 0 {
                onGotTopGrossingApp(feed: RepositoryManager.shared.topGrossingAppModel)
                sIsLoading.onNext(false)
            } else {
                sError.onNext(AppError.networkError)
            }
        }
    }
}
