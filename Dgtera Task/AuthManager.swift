//
//  AuthManager.swift
//  Dgtera Task
//
//  Created by Walid Ahmed on 13/04/2024.
//

import Foundation
import Alamofire

protocol AuthProtocol {
    func login(params: Parameters,completion: @escaping (Result<AuthResponseModel, Error>) -> Void)
}
class AuthManager: AuthProtocol {
    let network = NetworkManager()
    func login(params: Parameters,completion: @escaping (Result<AuthResponseModel, Error>) -> Void) {
        Task {
            do {
                let response = try await network.request(method: .post, url: Consts.LOGIN, headers: [:], params: params, of: AuthResponseModel.self)
                await MainActor.run {
                    completion(.success(response))
                }
            } catch {
                await MainActor.run {
                    completion(.failure(error))
                }
            }
        }
    }
}
