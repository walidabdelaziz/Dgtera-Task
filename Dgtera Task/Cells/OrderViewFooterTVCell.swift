//
//  OrderViewFooterTVCell.swift
//  Dgtera Task
//
//  Created by Walid Ahmed on 14/04/2024.
//

import UIKit

class OrderViewFooterTVCell: UITableViewCell {

    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var paybgV: UIView!
    @IBOutlet weak var payLbl: UILabel!
    @IBOutlet weak var totalDetailsLbl: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    
    var products: [Products]? {
        didSet {
            guard let products = products else { return }
            let totalPrice = products.reduce(0.0) { result, product in
                guard let count = product.orderViewCount, let price = product.lstPrice else { return result }
                return result + (Double(count) * price)
            }

            [totalDetailsLbl, priceLbl].forEach {
                $0?.text = "\(totalPrice) \(Utils.getAppCurrency())"
            }
            totalLbl.text = "Total (\(products.count) products)"
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
