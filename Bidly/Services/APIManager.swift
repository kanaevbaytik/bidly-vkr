//
//  APIManager.swift
//  Bidly
//
//  Created by Baytik  on 4/3/25.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    private let baseURL = "http://yourapi.com"
    
    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(baseURL)/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["email": email, "password": password]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("Error: \(error)")
                completion(false)
                return
            }
            if let data = data {
                let token = String(data: data, encoding: .utf8)
                if token != nil {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }.resume()
    }
    func register(name:String, email: String, password: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(baseURL)/register")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["name": name, "email": email, "password": password]
        request.httpBody = try? JSONEncoder().encode(body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print("Error: \(error)")
                completion(false)
                return
            }
            if let data = data {
                let token = String(data: data, encoding: .utf8)
                if token != nil {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }.resume()
    }
}
