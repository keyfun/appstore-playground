//
//  RepositoryManager.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/13/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

final class RepositoryManager {
    
    static let shared = RepositoryManager()
    
    var topFreeAppModel = Feed()
    var grossingAppModel = Feed()
    
    private init() {
        
    }
    
}
