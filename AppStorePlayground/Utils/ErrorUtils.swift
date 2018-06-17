//
//  ErrorUtils.swift
//  AppStorePlayground
//
//  Created by Key Hui on 6/17/18.
//  Copyright © 2018 keyfun. All rights reserved.
//

import Foundation

enum AppError: Error {
    case networkError, serverError
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "Network Error"
        case .serverError:
            return "Server Error"
        }
    }
}
