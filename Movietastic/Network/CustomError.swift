//
//  CustomError.swift
//  Movietastic
//
//  Created by Macbook Pro on 01/10/2020.
//

import Foundation

enum UrlErrors: Error {
    case invalidURL
    case detailsNotFound
}

extension UrlErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("You provided an incorrect url", comment: "Invalid URL")
        case .detailsNotFound:
            return NSLocalizedString("The details for this movie are not available", comment: "Details Not Found")
        }
    }
}
