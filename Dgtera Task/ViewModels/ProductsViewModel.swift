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
import Reachability

class ProductsViewModel {
    let isLoading = BehaviorRelay<Bool>(value: false)
    var products = BehaviorRelay<[Products]>(value: [])
    var orderItems = BehaviorRelay<[Products]>(value: [])
    let dataManager = SQLiteDataManager.shared
    let reachability = try! Reachability()
    
    init() {
        getProductsBasedOnNetwork()
     }

    func getProductsBasedOnNetwork() {
         reachability.whenReachable = {[weak self] _ in
             guard let self = self else{return}
             self.getProducts()
         }
         reachability.whenUnreachable = { [weak self] _ in
             guard let self = self else{return}
             self.loadProductsFromDatabase()
         }
         do {
             try reachability.startNotifier()
         } catch {
             print("Unable to start notifier")
         }
     }

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
                let savedProducts = dataManager.getProducts()
                // Check if all saved products are present in the response products
                let allSavedProductsInResponse = savedProducts.allSatisfy { savedProduct in
                    response.contains { $0.id == savedProduct.id }
                }
                // Check if all response products are present in the saved products
                let allResponseProductsInSaved = response.allSatisfy { responseProduct in
                    savedProducts.contains { $0.id == responseProduct.id }
                }
                // If all saved products are present in the response products and vice versa, they are equal
                if allSavedProductsInResponse && allResponseProductsInSaved {
                    self.loadProductsFromDatabase()
                } else {
                    // If not all saved products are present in the response
                    self.products.accept(response)
                    self.dataManager.saveProducts(response)
                }
            case .failure(let error):
                print("error is \(error)")
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
            updateOrderItems()
        }
    }
    private func updateOrderItems() {
        dataManager.saveProducts(products.value)
        // Filter order items based on products with non-zero order view count
        filter_Products_BasedOn_OrderView_Count(products: products.value)
    }
    private func loadProductsFromDatabase() {
        let savedProducts = dataManager.getProducts()
        products.accept(savedProducts)
        // Update order items based on saved products
        filter_Products_BasedOn_OrderView_Count(products: savedProducts)
    }
    func filter_Products_BasedOn_OrderView_Count(products: [Products]){
        let orderedProducts = products.filter { $0.orderViewCount ?? 0 > 0 }
        orderItems.accept(orderedProducts)
    }
    func resetOrderView(){
        orderItems.accept([])
        var updatedProducts = products.value
        updatedProducts.indices.forEach { index in
            updatedProducts[index].orderViewCount = 0
        }
        products.accept(updatedProducts)
        dataManager.saveProducts(products.value)
    }
}
