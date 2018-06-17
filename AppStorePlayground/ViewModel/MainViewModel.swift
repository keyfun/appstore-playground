//
//  MainViewModel.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/13/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

import RxSwift

final class MainViewModel: BaseViewModel {

    var sGotTopFreeApp = PublishSubject<Void>()
    var topFreeAppModel: Feed?

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
    }

    func fetchData() {
        APIManager.shared.getTopFreeApp()
    }

    private func onGotTopFreeApp(feed: Feed) {
        topFreeAppModel = feed
        sGotTopFreeApp.onNext(())
    }
    
    func getTopFreeAppCount() -> Int {
        return topFreeAppModel?.entries?.count ?? 0
    }

}
