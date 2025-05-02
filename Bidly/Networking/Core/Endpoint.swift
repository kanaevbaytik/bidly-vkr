//
//  Endpoint.swift
//  Bidly
//
//  Created by Baytik  on 28/4/25.
//


import Foundation

struct Endpoint {
    let path: String
    let method: HTTPMethod
    let headers: [String: String]
    let body: Data?
    
    var url: URL {
        URL(string: "https://your-keycloak-domain.com")!.appendingPathComponent(path)
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

