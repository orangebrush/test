//
//  RootTBV.swift
//  government_park
//
//  Created by YiGan on 18/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
import gov_sdk
class RootTBV: UITabBarController {
    
    override func viewWillAppear(_ animated: Bool) {
        
        //设置item大小
        let height: CGFloat = 49 / 2 //tabBar.backgroundImage!.size.height / 2
        let itemSize = CGSize(width: height, height: height)
        
        //载入（坪山智慧经服）
        let contentNC = UIStoryboard(name: "Contents", bundle: Bundle.main).instantiateViewController(withIdentifier: "contents")
        viewControllers?[0] = contentNC
        //tabBar.items?[1].image = UIImage(named: "resource/tabbar/map")?.transfromImage(size: itemSize)?.withRenderingMode(.alwaysOriginal)
        //tabBar.items?[1].selectedImage = UIImage(named: "resource/tabbar/map_selected")?.transfromImage(size: itemSize)?.withRenderingMode(.alwaysOriginal)
        
        //载入（我的）
        let meNC = UIStoryboard(name: "Me", bundle: Bundle.main).instantiateInitialViewController()
        viewControllers?[1] = meNC!
    }
    
    override func viewDidLoad() {
        config()
        createContents()
    }
    
    private func config(){

        let params = NewsPageParams()
        params.page = 1
        params.pageSize = 8
        Handler.getPageNews(withParam: params){
            resultCode, message, newspageModel in
            print("resultCode:\(resultCode)\n")
            print("message:\(message)\n")
            print("newsPageMode: \(String(describing: newspageModel))\n")
        }
        //修改返回按钮颜色
        UINavigationBar.appearance().tintColor = .subWord
        
        let attributed = NSAttributedString(string: "test", attributes: [NSForegroundColorAttributeName: UIColor.red, NSFontAttributeName: UIFont.small])
  
    }
    
    private func createContents(){
        
    }
}
