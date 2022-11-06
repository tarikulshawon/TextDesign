//
//  UIColor+Extension.swift
//  BubbleIt
//
//  Created by Abhi Makadia on 21/05/20.
//  Copyright © 2020 Abhi Makadia. All rights reserved.
//

import UIKit

extension UIColor{
    static let customOrangeColor = UIColor.init(red:246.0/255.0, green: 100.0/255.0, blue: 109/255.0, alpha: 1.0)
    static let customBlueColor = UIColor.init(red:75.0/255.0, green: 200.0/255.0, blue: 255.0/255.0, alpha: 1.0)
}


extension UIColor {
    convenience init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
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
}
