//
//  NetworkRequest.swift
//  RadioAppCleanSwiftUI
//
//  Created by Furkan ic on 31.07.2024.
//

import Foundation

protocol NetworkRequest {
    
    var baseUrl: URL { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Encodable? { get }
    var queryItems: Encodable? { get }
    var authentication: RequestAuthentication? { get }
    
    func urlRequest() throws -> URLRequest
}

extension NetworkRequest {
    //MARK: credential here
    var authentication: RequestAuthentication? {
        nil
    }
    
    func url() throws -> URL {
        guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)
        else {
            throw NetworkError.invalidUrl
        }
        
        let queryItemsDictionary = try queryItems?.toDictionary() ?? [:]
        components.path = path
        components.queryItems = queryItemsDictionary.map({ URLQueryItem(name: $0.key, value: "\($0.value)")})
        
        guard let url = components.url else {
            throw NetworkError.invalidUrl
        }
        
        return url
    }
    
    func urlRequest() throws -> URLRequest {
        let url = try url()
        var urlRequest = URLRequest(url: url, authentication: authentication)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        
        if let body {
            let bodyParameters = try body.toDictionary() ?? [:]
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters)
        }
        return urlRequest
    }
}

struct RequestAuthentication {
    let username: String
    let password: String
}

extension URLRequest {
    init(url: URL, authentication: RequestAuthentication?) {
        self.init(url: url)
        if let authentication {
            let credential = "\(authentication.username):\(authentication.password)"
            let data = credential.data(using: .utf8)
            setValue("Basic \(data!.base64EncodedString())", forHTTPHeaderField: "Autorization")
        }
    }
}

private extension Encodable {
    func toDictionary() throws -> [String: Any]? {
        let data = try JSONEncoder().encode(self)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData as? [String: Any]
    }
}
