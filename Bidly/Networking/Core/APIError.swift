//
//  APIError.swift
//  Bidly
//
//  Created by Baytik  on 28/4/25.
//


import Foundation

enum APIError: Error {
    case invalidResponse
    case invalidData
    case decodingError
    case unauthorized
    case serverError(statusCode: Int)
    case custom(error: Error)
}
