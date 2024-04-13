//
//  Utils.swift
//  Dgtera Task
//
//  Created by Walid Ahmed on 13/04/2024.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import SDWebImage

class Utils{
    static var indicator: NVActivityIndicatorView?
    static func showLoader(_ view: UIView) {
        if indicator == nil {
            let width = view.frame.width * 0.2
            let frame = CGRect(origin: CGPoint(x: view.frame.midX - width / 2, y: view.frame.midY - width / 2),
                               size: CGSize(width: width, height: width))
            indicator = NVActivityIndicatorView(frame: frame, type: .ballSpinFadeLoader, color: .PrimaryColor, padding: 8)
            view.addSubview(indicator!)
        }
        indicator!.startAnimating()
    }
    
    static func hideLoader() {
        if indicator != nil {
            indicator?.stopAnimating()
            indicator = nil
        }
    }
    static func setImageFromBase64(imageBase64: String?, img: UIImageView, placeholder: String? = nil) {
        guard let base64String = imageBase64, let imageData = Data(base64Encoded: base64String) else {
            img.image = placeholder != nil ? UIImage(named: placeholder!) : nil
            img.contentMode = .scaleAspectFill
            return
        }
        guard let image = UIImage(data: imageData) else {
            img.image = placeholder != nil ? UIImage(named: placeholder!) : nil
            img.contentMode = .scaleAspectFill
            return
        }
        img.image = image
    }
    static func getAppCurrency() -> String{
        return "SAR"
    }
}
