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
    let products = BehaviorRelay<[Products]>(value: [])

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
}
