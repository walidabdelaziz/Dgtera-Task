//
//  LoginVC.swift
//  Dgtera Task
//
//  Created by Walid Ahmed on 13/04/2024.
//

import UIKit
import RxSwift
import RxCocoa

class LoginVC: UIViewController {

    let authViewModel = AuthViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var welcomeLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        bindViewModel()
    }
    func bindViewModel(){
        // call login API after pressing login button
        loginBtn.rx.tap
            .bind(onNext: {[weak self] in
                guard let self = self else{return}
                authViewModel.login()
            }).disposed(by:disposeBag)
        
        // show loader
        authViewModel.isLoading.asObservable()
            .bind { (loading) in
                loading ? Utils.showLoader(self.view) : Utils.hideLoader()
            }.disposed(by: disposeBag)
        
        // check success status
        authViewModel.isSuccess.asObservable()
            .bind { [weak self](success) in
                guard let self = self else{return}
                if success {
                    self.navigateToProductsScreen()
                }
            }.disposed(by: disposeBag)
        
        // check error message if exists
        authViewModel.errorMessage
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] errorMessage in
                guard let self = self else{return}
                if errorMessage != nil{
                    self.showDialogPopup(title: "Error", message: errorMessage ?? "") {[weak self] in
                        guard let self = self else{return}
                        self.navigateToProductsScreen()
                    }
                }
            }).disposed(by: disposeBag)
    }
    func navigateToProductsScreen(){
        let storyboard = UIStoryboard(name: "Products", bundle: nil)
        let ProductsVC = storyboard.instantiateViewController(withIdentifier: "ProductsVC")
        navigationController?.pushViewController(ProductsVC, animated: true)
    }
}
