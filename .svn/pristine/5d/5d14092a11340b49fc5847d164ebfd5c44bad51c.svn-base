//
//  Color+Extension.swift
//  government_park
//
//  Created by YiGan on 18/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
extension UIColor{
    convenience init(colorHex hex: UInt, alpha: CGFloat = 1) {
        var aph = alpha
        if aph < 0 {
            aph = 0
        }else if aph > 1 {
            aph = 1
        }
        
        self.init(red: CGFloat((hex & 0xFF0000) >> 16) / 255,
                  green: CGFloat((hex & 0x00FF00) >> 8) / 255,
                  blue: CGFloat(hex & 0x0000FF) / 255,
                  alpha: aph)
    }
    
    //常用颜色
    static let word =       UIColor(colorHex: 0x332f2f, alpha: 1)
    static let subWord =    UIColor(colorHex: 0x3c3b3e, alpha: 1)
    static let summary =    UIColor(colorHex: 0x9a9a93, alpha: 1)
    static let light =      UIColor(colorHex: 0xd9d9d5, alpha: 1)
    static let button =     UIColor(colorHex: 0x79b2c5, alpha: 1)
}

