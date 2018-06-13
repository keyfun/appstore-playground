//
//  MainViewModel.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/13/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

final class MainViewModel {
    
    func fetchData() {
        APIManager.shared.getTopGrossingApp()
        APIManager.shared.getTopFreeApp()
    }
    
}
