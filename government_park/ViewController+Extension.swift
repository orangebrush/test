//
//  ViewController+Extension.swift
//  government_park
//
//  Created by YiGan on 21/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
typealias Closure = ()->()
var notifList = [(title: String, duration: TimeInterval, closure: Closure?)]()
var notifView: UIView?
extension UIViewController{
    //MARK:- 顶部提示
    func notif(withTitle title: String, duration: TimeInterval = 3, closure: Closure?){
        if notifView != nil{
            notifList.append((title: title, duration: duration, closure: closure))
        }else{
            let notifFrame = CGRect(x: 0, y: -64, width: view_size.width, height: 64)
            notifView = UIView(frame: notifFrame)
            notifView?.alpha = 0.5
            notifView?.backgroundColor = .clear
            
            //添加背景
            let gradient: CAGradientLayer = CAGradientLayer()
            gradient.frame = notifView!.bounds
            gradient.locations = [0, 1]
            gradient.startPoint = CGPoint(x: 0, y: 0)
            gradient.endPoint = CGPoint(x: 0, y: 1)
            gradient.colors = [UIColor.white.cgColor, UIColor.white.cgColor]
            gradient.cornerRadius = 20
            gradient.shadowColor = UIColor.black.cgColor
            gradient.shadowOffset = .zero
            gradient.shadowOpacity = 0.5
            gradient.shadowRadius = 5
            notifView?.layer.addSublayer(gradient)
            
            //添加文字
            let labelFrame = CGRect(x: 0, y: 20, width: notifView!.frame.width, height: notifView!.frame.height - 20)
            let label = UILabel(frame: labelFrame)
            label.textAlignment = .center
            label.textColor = .black
            label.font = .middle
            label.text = title
            notifView?.addSubview(label)
            
            //添加点击
            let tap = UITapGestureRecognizer(target: self, action: #selector(clickNotif(tap:)))
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            notifView?.addGestureRecognizer(tap)
            
            
            self.view.window?.addSubview(notifView!)
            
            closure?()
            
            //动画
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                self.showNotifView()
            }, completion: {
                complete in
                if complete {
                    _ = delay(duration - 0.3 * 2, task: {
                        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                            self.hiddenNotifView()
                        }, completion: {
                            complete in
                            self.clickNotif(tap: tap)
                        })
                    })
                }else{
                    self.clickNotif(tap: tap)
                }
            })
        }
    }
    
    private func checkNotifList(){
        
        guard let firstNotif = notifList.first else {
            return
        }
        
        notifList.removeFirst()
        notif(withTitle: firstNotif.title, duration: firstNotif.duration, closure: firstNotif.closure)
    }
    
    private func showNotifView(){
        notifView?.frame.origin.y = 0
        notifView?.alpha = 1
    }
    
    private func hiddenNotifView(){
        notifView?.frame.origin.y = -notifView!.frame.height
        notifView?.alpha = 0
    }
    
    @objc private func clickNotif(tap: UITapGestureRecognizer){
        notifView?.removeGestureRecognizer(tap)
        notifView?.removeFromSuperview()
        notifView = nil
        
        checkNotifList()
    }
    
    //MARK:- 登录弹窗
    func login(){
        let loginVC = UIStoryboard(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "login") as! LoginVC
        navigationController?.show(loginVC, sender: nil)
    }
    
    //MARK:- 修改密码
    func changePassword(){
        let changePasswordVC = UIStoryboard(name: "Login", bundle: Bundle.main).instantiateViewController(withIdentifier: "changepassword") as! ChangePasswordVC
        navigationController?.show(changePasswordVC, sender: nil)
    }
}
