//
//  NetworkError.swift
//  RadioAppCleanSwiftUI
//
//  Created by Furkan ic on 30.07.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case requestFailed(Error)
    case decodingFailed(Error?)
    case serverError(Int, String?)
    case failedToLoad
    case unknown
}

struct ServerError: Decodable {
    let message: String
}
