//
//  NetworkError.swift
//  User Info
//
//  Created by Маргарита Черняева on 2/26/21.
//

import Foundation

enum NetworkError: Error {
    case unknownError
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unknownError:
            return NSLocalizedString("Something wrong with self", comment: "")
        }
    }
}

