//
//  ProductsVC.swift
//  Dgtera Task
//
//  Created by Walid Ahmed on 13/04/2024.
//

import UIKit
import RxSwift
import RxCocoa

class ProductsVC: UIViewController {
    
    let productsViewModel = ProductsViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var productsCV: UICollectionView!
    @IBOutlet weak var productsLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setCollectionViewsUI(collectionView: productsCV, nibName: "ProductsCell")
        bindViewModel()
    }
    func setCollectionViewsUI(collectionView: UICollectionView, nibName: String){
        collectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
        let layout = UICollectionViewFlowLayout()
        let cellWidth = collectionView.frame.width / 4
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    func bindViewModel(){
        productsViewModel.getProducts()
        
        productsViewModel.products
             .bind(to: productsCV.rx.items(cellIdentifier: "ProductsCell", cellType: ProductsCell.self)) { row, product, cell in
                 cell.product = product
             }
             .disposed(by: disposeBag)
        // show loader
        productsViewModel.isLoading.asObservable()
            .bind { (loading) in
                loading ? Utils.showLoader(self.view) : Utils.hideLoader()
            }.disposed(by: disposeBag)
    }
}
