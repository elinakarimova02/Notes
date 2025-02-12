//
//  Extension+UIColor.swift
//  Notes
//
//  Created by Elina Karimova on 11/2/25.
//

import UIKit

extension UIColor {
    func rgb(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) -> UIColor{
        return UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: alpha)
    }
}
