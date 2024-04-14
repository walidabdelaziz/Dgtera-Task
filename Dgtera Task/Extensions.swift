//
//  Extensions.swift
//  Dgtera Task
//
//  Created by Walid Ahmed on 13/04/2024.
//

import Foundation
import UIKit

extension UIViewController{
    func showDialogPopup(title: String, message: String, completion: (() -> Void)? = nil) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
               completion?()
           })
           present(alert, animated: true, completion: nil)
       }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    @nonobjc class var PrimaryColor: UIColor {
        return UIColor(hexString: "#EB8855")
    }
}
extension UIView{
    func setGestureRecognizer(gestureSelector: UITapGestureRecognizer){
        addGestureRecognizer(gestureSelector)
        isUserInteractionEnabled = true
    }
}
