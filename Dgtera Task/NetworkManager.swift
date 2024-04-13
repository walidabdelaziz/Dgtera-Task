//
//  NetworkManager.swift
//  Dgtera Task
//
//  Created by Walid Ahmed on 13/04/2024.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func request<T: Decodable>(_ url: String,
                                method: HTTPMethod = .get,
                                parameters: Parameters? = nil,
                                encoding: ParameterEncoding = JSONEncoding.prettyPrinted,
                                withToken: Bool? = false) async throws -> (T, Int?) {
        let headers = ["Accept": "application/json"]
        if parameters != nil {
            print("params: \(parameters ?? Parameters())")
        }
        print("URL: \(url)")
        
        let (data, response) = try await URLSession.shared.data(from: URL(string: url)!)
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            print("response: \(decodedObject)")
            return (decodedObject, statusCode)
        } catch {
            print(error)
            throw error
        }
    }
    func requestJSON(_ url: String,
                     method: HTTPMethod = .get,
                     parameters: Parameters? = nil,
                     encoding: ParameterEncoding = JSONEncoding.prettyPrinted,
                     withToken: Bool? = false) async throws -> (JSON, Int?) {
        let headers = ["Accept": "application/json"]
        if parameters != nil {
            print("params: \(parameters ?? Parameters())")
        }
        print("URL: \(url)")
        let (data, response) = try await URLSession.shared.data(from: URL(string: url)!)
        let statusCode = (response as? HTTPURLResponse)?.statusCode
        let json = JSON(data)
        return (json, json["response_status"].int ?? 301)
    }
}
