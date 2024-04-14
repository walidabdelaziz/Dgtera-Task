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
    
    @IBOutlet weak var noDataLbl: UILabel!
    @IBOutlet weak var orderTV: UITableView!
    @IBOutlet weak var productsCV: UICollectionView!
    @IBOutlet weak var productsLbl: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setOrderTableViewUI()
        setProductsCollectionViewsUI(collectionView: productsCV, nibName: "ProductsCell")
        bindViewModel()
    }
    func setOrderTableViewUI(){
        orderTV.rx.setDelegate(self).disposed(by: disposeBag)
        orderTV.register(UINib(nibName: "OrderViewTVCell", bundle: nil), forCellReuseIdentifier: "OrderViewTVCell")
        orderTV.register(UINib(nibName: "OrderViewFooterTVCell", bundle: nil), forCellReuseIdentifier: "OrderViewFooterTVCell")
    }
    func setProductsCollectionViewsUI(collectionView: UICollectionView, nibName: String){
        collectionView.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
        let layout = UICollectionViewFlowLayout()
        let cellWidth = collectionView.frame.width / 3
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth * 1.09)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
    func bindViewModel(){
        // bind order view
        productsViewModel.orderItems
            .bind(to: orderTV.rx.items(cellIdentifier: "OrderViewTVCell", cellType: OrderViewTVCell.self)) { row, orderItem, cell in
                cell.orderItem = orderItem
            }.disposed(by: disposeBag)

        // bind products
        productsViewModel.products
             .bind(to: productsCV.rx.items(cellIdentifier: "ProductsCell", cellType: ProductsCell.self)) { row, product, cell in
                 cell.product = product
             }.disposed(by: disposeBag)
        
        // make products collection view clickable
        productsCV.rx.modelSelected(Products.self)
            .subscribe(onNext: { [weak self] product in
                guard let self = self else{return}
                self.orderTV.reloadData()
                self.productsViewModel.incrementOrderItemsCount(product: product)
            }).disposed(by: disposeBag)
        
        // show no data label
        productsViewModel.orderItems.asObservable()
            .bind(onNext: {[weak self] (orderItems) in
                guard let self = self else{return}
                self.noDataLbl.isHidden = orderItems.isEmpty ? false : true
                self.orderTV.isHidden = orderItems.isEmpty ? true : false
            }).disposed(by: disposeBag)
        
        // show loader
        productsViewModel.isLoading.asObservable()
            .bind { (loading) in
                loading ? Utils.showLoader(self.view) : Utils.hideLoader()
            }.disposed(by: disposeBag)
    }
}
extension ProductsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?{
        let cell = tableView.dequeueReusableCell(
                            withIdentifier: "OrderViewFooterTVCell")
                as! OrderViewFooterTVCell
        
        cell.paybgV.setGestureRecognizer(gestureSelector: UITapGestureRecognizer(target: self, action: #selector(paybgVTapped(gesture:))))
        let products = productsViewModel.orderItems.value
        cell.products = products
        return cell.contentView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    @objc func paybgVTapped(gesture: UIGestureRecognizer) {
        showDialogPopup(title: "Order Confirmed", message: "Order is now being prepared by the restaurant")
        productsViewModel.resetOrderView()
        orderTV.reloadData()
    }
}
