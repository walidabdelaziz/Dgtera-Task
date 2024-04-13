//
//  ProductsManager.swift
//  Dgtera Task
//
//  Created by Walid Ahmed on 13/04/2024.
//

import Foundation
import Foundation
import Alamofire

protocol ProductsProtocol {
    func getProducts(params: Parameters,completion: @escaping (Result<[Products], Error>) -> Void)
}
class ProductsManager: ProductsProtocol {
    let network = NetworkManager()
    func getProducts(params: Parameters,completion: @escaping (Result<[Products], Error>) -> Void) {
        Task {
            do {
                let response = try await network.request(method: .post, url: Consts.PRODUCTS, headers: [:], params: params, of: ProductsModel.self)
                await MainActor.run {
                    completion(.success(response.result ?? []))
                }
            } catch {
                await MainActor.run {
                    completion(.failure(error))
                }
            }
        }
    }
}
