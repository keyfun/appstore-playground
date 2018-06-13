//
//  LocaleUtils.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/14/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

import Foundation

struct LocaleUtils {
    
    private static func getStringForKey(key: String, from fileName: String? = nil) -> String {
        var Languagebundle: Bundle? = Bundle.main
        
        let bundlePath = Bundle.main.path(forResource: "Base", ofType: "lproj")
        if (bundlePath != nil) {
            Languagebundle = Bundle(path: bundlePath!)!
        }
        
        if let bundle = Languagebundle {
            let translatedString = bundle.localizedString(forKey: key as String, value: "", table: fileName)
            return translatedString
        }
        print("Language File Not Found")
        return key
    }
    
    static func getLocal(_ str: String) -> String {
        return self.getStringForKey(key: str)
    }
}

public func locale(_ str: String) -> String {
    return LocaleUtils.getLocal(str)
}
