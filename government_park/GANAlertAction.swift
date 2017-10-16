//
//  GANAlertAction.swift
//  Ball
//
//  Created by GAN-mac on 16/1/11.
//  Copyright © 2016年 gan. All rights reserved.
//

import Foundation
import UIKit
let kNotifShared = "sharenotif"
class GANAlertAction: UIView {
    
    var height:CGFloat = 0
    init(){
        height = view_size.height * 0.3
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: view_size.height), size: CGSize(width: view_size.width, height: height)))
        config()
        createContents()
    }
    
    fileprivate func config(){
        swipIn()
    }
    
    fileprivate func createContents(){
        for index in 0..<6{
            let singleWechat = UIButton(type: UIButtonType.custom)
            singleWechat.setImage(UIImage(named: "s_\(index + 1)"), for: UIControlState())
            singleWechat.tag = index + 1
            singleWechat.frame = CGRect(x: view_size.width / 6 * CGFloat(index + 1) - 25, y: frame.size.height * 0.3, width: 50, height: 50)
            singleWechat.addTarget(self, action: #selector(GANAlertAction.pressBtn(_:)), for: .touchUpInside)
            addSubview(singleWechat)
        }
        
//        let cancelButton = UIButton(type: UIButtonType.Custom)
//        cancelButton.setTitle("Cancel", forState: UIControlState.Normal)
//        cancelButton.setTitleColor(UIColor(red: 0.7, green: 0.9, blue: 0.9, alpha: 1), forState: .Normal)
//        cancelButton.frame = CGRect(x: 0, y: frame.size.height * 0.7, width: frame.size.width, height: frame.size.height * 0.3)
//        cancelButton.addTarget(self, action: "swipOut", forControlEvents: .TouchUpInside)
//        addSubview(cancelButton)
    }
    
    func swipIn(){
        UIView.animate(withDuration: 1, animations: {
            self.frame = CGRect(origin: CGPoint(x: 0, y: view_size.height - self.height), size: CGSize(width: view_size.width, height: self.height))
            }, completion: {
                finished in
                //移动完成
        })
    }
    
    func swipOut(){
        UIView.animate(withDuration: 1, animations: {
            self.frame = CGRect(origin: CGPoint(x: 0, y: view_size.height), size: CGSize(width: view_size.width, height: self.height))
            }, completion: {
                finished in
                //移动完成
        })
    }
    
    func pressBtn(_ button:UIButton){
        NotificationCenter.default.post(name: Notification.Name(rawValue: kNotifShared), object: button.tag)
        swipOut()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
