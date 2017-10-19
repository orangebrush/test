//
//  FindPassword.swift
//  government_park
//
//  Created by YiGan on 30/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
import gov_sdk
class FindPasswordVC: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var newView: UIView!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var verificationTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var verificationButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var resetButtonConstraint: NSLayoutConstraint!
    
    private var isLagel = false{
        didSet{
            resetButtonConstraint.constant = isLagel ? .edge8 : -75
            newView.isHidden = !isLagel
        }
    }
    private var account: String?
    private var verification: String?
    private var newPassword: String?
    
    //MARK:- init------------------------------
    override func viewDidLoad() {
        
        config()
        createContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        isLagel = false
    }
    
    private func config(){
        
        if let localAccount = userDefaults.string(forKey: "account"){
            accountTextField.text = localAccount
        }
    }
    
    private func createContents(){
        
    }
    
    //MARK: 返回登录页
    @IBAction func back(_ sender: Any){
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: 关闭登录注册页
    @IBAction func close(_ sender: Any){
        
        guard let viewControllers = navigationController?.viewControllers else{
            return
        }
        let tagetVC = viewControllers[viewControllers.count - 2]
        navigationController?.popToViewController(tagetVC, animated: true)
    }
    
    //MARK: 输入
    @IBAction func valueChange(_ sender: UITextField){
        switch sender.tag {
        case 0:
            account = sender.text
        case 1:
            verification = sender.text
        default:
            newPassword = sender.text
        }
    }
    
    //MARK: 获取验证码
    @IBAction func getVerification(_ sender: Any){
        
        account = accountTextField.text
        
        let accountTuple = isAccountLegal(withString: account)
        
        guard accountTuple.isLegal else {
            notif(withTitle: accountTuple.message, duration: 1, closure: nil)
            return
        }
        
        //存储账号
        userDefaults.set(account!, forKey: "account")
        
        NetworkHandler.share().account.getResetVerifyCode(withAccount: account!) { (resultCode, message, data) in
            DispatchQueue.main.async {
                
                self.notif(withTitle: message, closure: nil)
            }
        }
    }
    
    //MARK: 校验验证码or修改密码
    @IBAction func setPassword(_ sender: Any){
        if isLagel {
            //修改密码
            newPassword = passwordTextField.text
            
            let accountTuple = isAccountLegal(withString: account)
            let newPasswordTuple = isPasswordLegal(withString: newPassword)
            
            guard accountTuple.isLegal else {
                notif(withTitle: accountTuple.message, duration: 1, closure: nil)
                return
            }
            
            guard newPasswordTuple.isLegal else {
                notif(withTitle: newPasswordTuple.message, closure: nil)
                return
            }
            
            //存储账号密码
            userDefaults.set(account!, forKey: "account")
            userDefaults.set(newPassword!.sha1(), forKey: "password")
            userDefaults.set(newPassword!, forKey: "originalPassword")
            NetworkHandler.share().account.reset(withPassword: newPassword!.sha1(), closure: { (resultCode, message, data) in
                DispatchQueue.main.async {
                    self.isLagel = false        //重置验证码为未验证
                    guard resultCode == .success else{
                        self.notif(withTitle: message, closure: nil)
                        return
                    }
                    
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }else{
            //校验验证码
            verification = verificationTextField.text
            let verificationTuple = isVerifyCodeLegal(withString: verification)
            guard verificationTuple.isLegal else{
                notif(withTitle: verificationTuple.message, closure: nil)
                return
            }
            
            NetworkHandler.share().account.checkResetVerifyCode(withVerfiyCode: verification!, closure: { (resultCode, message, data) in
                DispatchQueue.main.async {
                    guard resultCode == .success else{
                        self.notif(withTitle: message, closure: nil)
                        return
                    }
                    self.isLagel = true     //设置验证码通过
                }
            })
        }
        
    }
}
