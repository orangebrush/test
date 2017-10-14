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
    
    private var isLagel = false
    private var account: String?
    private var verification: String?
    private var newPassword: String?
    
    //MARK:- init------------------------------
    override func viewDidLoad() {
        
        config()
        createContents()
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
        
    }
    
    //MARK: 校验验证码or修改密码
    @IBAction func setPassword(_ sender: Any){
        if isLagel {
            //修改密码
        }else{
            //校验验证码
        }
    }
}
