//
//  Utils.swift
//  Dgtera Task
//
//  Created by Walid Ahmed on 13/04/2024.
//

import Foundation
import NVActivityIndicatorView

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
}
