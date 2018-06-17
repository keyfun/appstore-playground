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
    var topGrossingAppModel: Feed?
    
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
    
    func fetchData() {
        APIManager.shared.getTopGrossingApp()
    }
    
    private func onGotTopGrossingApp(feed: Feed) {
        topGrossingAppModel = feed
        sGotTopGrossingApp.onNext(())
    }
    
    func getGrossingAppCount() -> Int {
        return topGrossingAppModel?.entries?.count ?? 0
    }
}
