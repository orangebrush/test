//
//  Image+Extension.swift
//  government_park
//
//  Created by YiGan on 18/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
extension UIImage{
    
    //MARK:- 根据尺寸重新绘制图像
    func transfromImage(size: CGSize) -> UIImage?{
        
        let scale: CGFloat = 2
        let newWidth = size.width * scale
        let newHeight = size.height * scale
        
        let resultSize = CGSize(width: newWidth, height: newHeight)
        UIGraphicsBeginImageContext(resultSize)
        self.draw(in: CGRect(origin: .zero, size: resultSize))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIImage(cgImage: result!.cgImage!, scale: scale, orientation: UIImageOrientation.up)
    }
}
