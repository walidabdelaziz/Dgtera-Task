//
//  NetworkManager.swift
//  Dgtera Task
//
//  Created by Walid Ahmed on 13/04/2024.
//

import Foundation
import Alamofire

actor NetworkManager {
    func request<T: Decodable>(
        method: HTTPMethod,
        url: String,
        headers: [String: String],
        params: Parameters?,
        of type: T.Type
    ) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            AF.request(
                url,
                method: method,
                parameters: params,
                encoding: JSONEncoding.prettyPrinted,
                headers: HTTPHeaders(headers)
            ).responseDecodable(of: type) { response in
                print("url \(url)")
                print("params \(params ?? [:])")
                switch response.result {
                case let .success(data):
                    print("response \(data)")
                    continuation.resume(returning: data)
                case let .failure(error):
                    print("error \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

