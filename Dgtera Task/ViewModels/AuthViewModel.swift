//
//  AuthViewModel.swift
//  Dgtera Task
//
//  Created by Walid Ahmed on 13/04/2024.
//

import Foundation
import RxSwift
import RxCocoa

class AuthViewModel {
    let errorMessage = BehaviorRelay<String?>(value: nil)
    let isSuccess = BehaviorRelay<Bool>(value: false)
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    func login() {
        isLoading.accept(true)
        let params: [String: Any] = [
            "jsonrpc": "2.0",
            "method": "call",
            "id": 1,
            "params": [
                "login": "api_key_client_1",
                "password": "9M2CstCBMrL_GA969gRvQgDiGWOivR7ht-znSr_ZqvOJjmEJaFyrrJF3cDvTtZQvMPTo8flglEcQR_9Od1onzg",
                "db": "comu_test_tomtom",
                "context": [
                    "display_default_code": false,
                    "tz": "Asia/Riyadh",
                    "false_name_ar": true,
                    "uid": 6,
                    "lang": "ar_001"
                ]
            ]
        ]
        AuthManager().login(params: params, completion: {[weak self] result in
            guard let self = self else{return}
            self.isLoading.accept(false)
            switch result {
            case .success(let response):
                // Process the data response here
                if response.result != nil{
                    self.isSuccess.accept(true)
                    self.errorMessage.accept(nil)
                }else{
                    self.isSuccess.accept(false)
                    self.errorMessage.accept(response.error?.message ?? "")
                }
                break
            case .failure(let error):
                self.isSuccess.accept(false)
                self.errorMessage.accept(error.localizedDescription)
                break
            }
        })
    }
}
