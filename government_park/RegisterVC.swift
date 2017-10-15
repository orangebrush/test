//
//  RegisterVC.swift
//  government_park
//
//  Created by YiGan on 30/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
import gov_sdk
class RegisterVC: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var verificationTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var verificationButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    private var account: String?
    private var legalAcctoun: String?
    private var verification: String?
    private var password: String?
    
    
    //MARK:- init-----------------------------------
    override func viewDidLoad() {
        
        config()
        createContents()
    }
    
    private func config(){
        
        topView.layer.cornerRadius = .cornerRadius
        registerButton.layer.cornerRadius = .cornerRadius
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
            password = sender.text
        }
    }
    
    //MARK: 获取验证码
    @IBAction func getVerification(_ sender: Any){
        
        account = accountTextField.text
        
        let accountTuple = isAccountLegal(withString: account)
        
        guard accountTuple.isLegal else {
            legalAcctoun = nil
            notif(withTitle: accountTuple.message, duration: 1, closure: nil)
            return
        }
        
        legalAcctoun = account
    }
    
    //MARK: 注册
    @IBAction func register(_ sender: Any){
        
        let passwordTuple = isPasswordLegal(withString: password)
        
        guard passwordTuple.isLegal else {
            notif(withTitle: passwordTuple.message, duration: 1, closure: nil)
            return
        }
        
        //判断是否修改过用户名
        guard account == legalAcctoun else {
            notif(withTitle: "需为新账号重新获取验证码", duration: 1, closure: nil)
            return
        }
        
        //存储账号密码
        userDefaults.set(account!, forKey: "account")
        userDefaults.set(password!.sha1(), forKey: "password")
        userDefaults.set(password!, forKey: "originalPassword")
    }
}
