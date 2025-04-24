//
//  APIEndpoints.swift
//  FoodBunch
//
//  Created by Furkan ic on 21.04.2025.
//

import Foundation

var BASE_URL = "https://s3-eu-west-1.amazonaws.com"

enum APIEndpoints {
    case retrieveProducts
    case retrieveProductDetail(String)
}

extension APIEndpoints: NetworkRequest {

    var commonHeaders: [String: String] {
        ["Conten-Type": "application/json"]
    }
    
    var baseUrl: URL {
        URL(string: BASE_URL)!
    }
    
    var path: String {
        switch self {
        case .retrieveProducts:
            "/developer-application-test/cart/list"
        case let .retrieveProductDetail(productID):
            "/developer-application-test/cart/\(productID)/detail"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .retrieveProducts:
            .get
        case .retrieveProductDetail(_):
                .get
        }
    }
    
    var headers: [String : String]? {
        commonHeaders
    }
    
    var body: Encodable? {
        switch self {
        case .retrieveProducts:
            nil
        case .retrieveProductDetail(_):
            nil
        }
    }
    
    var queryItems: Encodable? {
        switch self {
        case .retrieveProducts:
            nil
        case .retrieveProductDetail:
            nil
        }
    }
}
