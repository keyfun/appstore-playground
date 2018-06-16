//
//  MainViewModel.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/13/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

import RxSwift

final class MainViewModel {

    let disposeBag = DisposeBag()

    var sIsLoading = PublishSubject<Bool>()
    var sError = PublishSubject<Error>()
    var sGotGrossingApp = PublishSubject<Void>()
    var sGotTopFreeApp = PublishSubject<Void>()

    var topFreeAppModel: Feed?
    var grossingAppModel: Feed?

    init() {
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

    func fetchData() {
        APIManager.shared.getTopGrossingApp()
        APIManager.shared.getTopFreeApp()
    }

    private func onIsLoading(value: Bool) {
        print("isLoading = \(value)")
        sIsLoading.onNext(value)
    }

    private func onError(error: Error) {
        sError.onNext(error)
    }

    private func onGotTopGrossingApp(feed: Feed) {
        grossingAppModel = feed
        sGotGrossingApp.onNext(())
    }
    
    func getGrossingAppCount() -> Int {
        return grossingAppModel?.entries?.count ?? 0
    }

}
