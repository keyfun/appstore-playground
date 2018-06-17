//
//  BaseViewModel.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/17/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

import RxSwift

class BaseViewModel {
    
    internal let disposeBag = DisposeBag()
    var sIsLoading = PublishSubject<Bool>()
    var sError = PublishSubject<Error>()
    
    internal func onIsLoading(value: Bool) {
        print("isLoading = \(value)")
        sIsLoading.onNext(value)
    }
    
    internal func onError(error: Error) {
        sError.onNext(error)
    }
    
}
