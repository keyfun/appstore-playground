//
//  RepositoryManager.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/13/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

import Foundation
import SwiftyJSON

final class RepositoryManager {

    static let shared = RepositoryManager()
    private let defaults = UserDefaults.standard
    private let kTopFreeApp = "top_free_app"
    private let kTopGrossingApp = "top_grossing_app"

    var topFreeAppModel: Feed!
    var topGrossingAppModel: Feed!

    private init() {
        topFreeAppModel = Feed(loadJson(kTopFreeApp))
        topGrossingAppModel = Feed(loadJson(kTopGrossingApp))
        
        print("[RepositoryManager] init")
        print(topFreeAppModel.toString())
        print(topGrossingAppModel.toString())
    }

    private func saveJson(json: JSON, key: String) {
        let jsonString = json.rawString()!
        defaults.setValue(jsonString, forKey: key)
        defaults.synchronize()
    }

    private func loadJson(_ key: String) -> JSON {
        if let jsonString = defaults.value(forKey: key) as? String {
            if let json = jsonString.data(using: String.Encoding.utf8, allowLossyConversion: false) {
                return try! JSON(data: json)
            } else {
                return JSON("nil")
            }
        }
        return JSON("nil")
    }
    
    func saveTopFreeAppJson(_ json: JSON) {
        saveJson(json: json, key: kTopFreeApp)
    }
    
    func saveTopGrossingAppJson(_ json: JSON) {
        saveJson(json: json, key: kTopGrossingApp)
    }

}
