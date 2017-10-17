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
    
    private var isShow = false
    init(){
        height = view_size.height * 0.3
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: view_size.height), size: CGSize(width: view_size.width, height: height)))
        config()
        createContents()
    }
    
    fileprivate func config(){
        swipOut()
    }
    
    fileprivate func createContents(){
        for index in 0..<2{
            let singleWechat = UIButton(type: UIButtonType.custom)
            singleWechat.setImage(UIImage(named: "resource/share/s_\(index + 1)"), for: UIControlState())
            singleWechat.tag = index + 1
            singleWechat.frame = CGRect(x: view_size.width / 2 + CGFloat(index) * 80 - 40 - 25, y: frame.size.height * 0.2, width: 50, height: 50)
            singleWechat.addTarget(self, action: #selector(GANAlertAction.pressBtn(_:)), for: .touchUpInside)
            addSubview(singleWechat)
        }
    }
    
    func swip(){
        if isShow {
            swipOut()
        }else{
            swipIn()
        }
    }
    
    private func swipIn(){
        UIView.animate(withDuration: 1, animations: {
            self.isShow = true
            self.frame = CGRect(origin: CGPoint(x: 0, y: view_size.height - self.height), size: CGSize(width: view_size.width, height: self.height))
            }, completion: {
                finished in
                //移动完成
        })
    }
    
    private func swipOut(){
        UIView.animate(withDuration: 1, animations: {
            self.isShow = false
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
