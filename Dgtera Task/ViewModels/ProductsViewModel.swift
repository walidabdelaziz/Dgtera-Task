//
//  ProductsViewModel.swift
//  Dgtera Task
//
//  Created by Walid Ahmed on 13/04/2024.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class ProductsViewModel {
    let isLoading = BehaviorRelay<Bool>(value: false)
    var products = BehaviorRelay<[Products]>(value: [])
    var orderItems = BehaviorRelay<[Products]>(value: [])

    func getProducts() {
        isLoading.accept(true)

        let params: Parameters = [
            "params": [
                "model": "product.product",
                "args": [],
                "kwargs": [
                    "domain": [
                        ["active", "=", true],
                        ["invisible_in_ui", "=", true],
                        ["is_combo", "=", false],
                        ["sale_ok", "=", true],
                        ["available_in_pos", "=", true],
                        ["active", "=", true]
                    ],
                    "offset": 0,
                    "context": [
                        "display_default_code": false,
                        "tz": "Asia/Riyadh",
                        "false_name_ar": true,
                        "uid": 6,
                        "lang": "ar_001"
                    ],
                    "fields": [
                        "id", "display_name", "lst_price", "image_small", "original_name", "name_ar", "other_lang_name", "product_variant_ids", "sequence"
                    ],
                    "limit": false
                ],
                "method": "search_read"
            ],
            "jsonrpc": "2.0",
            "method": "call",
            "id": 1
        ]
        ProductsManager().getProducts(params: params, completion: {[weak self] result in
            guard let self = self else{return}
            self.isLoading.accept(false)
            switch result {
            case .success(let response):
                // Process the data response here
                self.products.accept(response)
                break
            case .failure(let error):
                print("error is \(error)")
                break
            }
        })
    }
    func incrementOrderItemsCount(product: Products) {
        var updatedProducts = products.value
        if let index = updatedProducts.firstIndex(where: { $0.id == product.id }) {
            if let orderViewCount = updatedProducts[index].orderViewCount {
                updatedProducts[index].orderViewCount = orderViewCount + 1
            } else {
                updatedProducts[index].orderViewCount = 1
            }
            products.accept(updatedProducts)
            // Filter order items based on products with non-zero order view count
            let orderedProducts = updatedProducts.filter { $0.orderViewCount ?? 0 > 0 }
            orderItems.accept(orderedProducts)
        }
    }
}
