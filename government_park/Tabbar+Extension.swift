//
//  Tabbar+Extension.swift
//  government_park
//
//  Created by YiGan on 22/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
extension UITabBarController{
    
    open override func awakeFromNib() {
        
        //tabBar.tintColor = .subWord
        
        /*
        var tabbarSize = tabBar.frame.size
        tabbarSize.width = view_size.width
        
        //修改底图与item图形
        if let backImage = UIImage(named: "resource/tabbar/background"){
            tabBar.backgroundImage = backImage.transfromImage(size: tabbarSize)
            tabBar.shadowImage = UIImage()
            
            let height: CGFloat = 49 / 2 //tabBar.backgroundImage!.size.height / 2
            let itemSize = CGSize(width: height, height: height)
            
            tabBar.items?[0].image = UIImage(named: "resource/tabbar/status")?.transfromImage(size: itemSize)?.withRenderingMode(.alwaysOriginal)
            tabBar.items?[1].image = UIImage(named: "resource/tabbar/map")?.transfromImage(size: itemSize)?.withRenderingMode(.alwaysOriginal)
            tabBar.items?[3].image = UIImage(named: "resource/tabbar/health")?.transfromImage(size: itemSize)?.withRenderingMode(.alwaysOriginal)
            tabBar.items?[4].image = UIImage(named: "resource/tabbar/me")?.transfromImage(size: itemSize)?.withRenderingMode(.alwaysOriginal)
            
            tabBar.items?[0].selectedImage = UIImage(named: "resource/tabbar/status_selected")?.transfromImage(size: itemSize)?.withRenderingMode(.alwaysOriginal)
            tabBar.items?[1].selectedImage = UIImage(named: "resource/tabbar/map_selected")?.transfromImage(size: itemSize)?.withRenderingMode(.alwaysOriginal)
            tabBar.items?[3].selectedImage = UIImage(named: "resource/tabbar/health_selected")?.transfromImage(size: itemSize)?.withRenderingMode(.alwaysOriginal)
            tabBar.items?[4].selectedImage = UIImage(named: "resource/tabbar/me_selected")?.transfromImage(size: itemSize)?.withRenderingMode(.alwaysOriginal)
        }
        
        //设置阴影
        tabbarSize.height += view_size.width * 0.06
        let shadowImage = UIImage(named: "resource/tabbar/shadow")?.transfromImage(size: tabbarSize)
        let shadowImageView = UIImageView(image: shadowImage)
        shadowImageView.frame.origin.y = -view_size.width * 0.06
        shadowImageView.layer.zPosition = -1
        shadowImageView.layer.opacity = 0.2
        tabBar.addSubview(shadowImageView)
         */
    }
}
