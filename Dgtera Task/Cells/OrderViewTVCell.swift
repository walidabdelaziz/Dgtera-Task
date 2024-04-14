//
//  OrderViewTVCell.swift
//  Dgtera Task
//
//  Created by Walid Ahmed on 14/04/2024.
//

import UIKit

class OrderViewTVCell: UITableViewCell {

    @IBOutlet weak var countLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    
    var orderItem: Products? {
        didSet {
            guard let orderItem = orderItem else { return }
            titleLbl.text = orderItem.displayName ?? ""
            countLbl.text = "\(orderItem.orderViewCount ?? 0)"
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
