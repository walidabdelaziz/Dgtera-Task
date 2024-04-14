//
//  ProductsCell.swift
//  Dgtera Task
//
//  Created by Walid Ahmed on 13/04/2024.
//

import UIKit

class ProductsCell: UICollectionViewCell {

    @IBOutlet weak var overlaybgV: UIView!
    @IBOutlet weak var productPriceLbl: UILabel!
    @IBOutlet weak var productNameLbl: UILabel!
    @IBOutlet weak var productImg: UIImageView!
    @IBOutlet weak var bgV: UIView!
    
    
    var product: Products? {
        didSet {
            guard let product = product else { return }

            Utils.setImageFromBase64(imageBase64: product.imageSmall?.stringValue ?? "", img: productImg)
            productNameLbl.text = product.displayName ?? ""
            productPriceLbl.text = "\(product.lstPrice ?? 0) \(Utils.getAppCurrency())"
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        [overlaybgV].forEach {
            $0?.backgroundColor =  .lightGray.withAlphaComponent(0.6)
        }
        productPriceLbl.textColor = .PrimaryColor
    }

}
