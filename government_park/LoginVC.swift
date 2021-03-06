//
//  LoginVC.swift
//  government_park
//
//  Created by YiGan on 30/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
import gov_sdk
class LoginVC: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    private var account: String?{return accountTextField.text}
    private var password: String?{return passwordTextField.text}
    
    
    //MARK:- init----------------------------------------
    override func viewDidLoad() {
        
        config()
        createContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.isNavigationBarHidden = true
    }
    
    private func config(){
        
        topView.layer.cornerRadius = .cornerRadius
        loginButton.layer.cornerRadius = .cornerRadius
        
        if let localAccount = userDefaults.string(forKey: "account"){
            accountTextField.text = localAccount
        }
        
        if let originPassword = userDefaults.string(forKey: "originalPassword"){
            passwordTextField.text = originPassword
        }
    }
    
    private func createContents(){
        
    }
    
    //MARK: 关闭页面
    @IBAction func close(_ sender: UIButton){
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: 输入
    @IBAction func valueChanged(_ sender: UITextField){
//        if sender.tag == 0 {
//            account = sender.text
//        }else{
//            password = sender.text
//        }
    }
    
    //MARK: 登录
    @IBAction func login(_ sender: Any){        
        
        let accountTuple = isAccountLegal(withString: account)
        let passwordTuple = isPasswordLegal(withString: password)
        
        guard accountTuple.isLegal else {
            notif(withTitle: accountTuple.message, duration: 1, closure: nil)
            return
        }
        
        guard passwordTuple.isLegal else {
            notif(withTitle: passwordTuple.message, duration: 1, closure: nil)
            return
        }
        
        //存储账号密码
        userDefaults.set(account!, forKey: "account")
        userDefaults.set(password!.sha1(), forKey: "password")
        userDefaults.set(password!, forKey: "originalPassword")
        userDefaults.synchronize()
        
        NetworkHandler.share().account.getUserinfo { (resultCode, message, user) in
            DispatchQueue.main.async {
                guard resultCode == .success else {
                    self.notif(withTitle: message, duration: 1, closure: nil)
                    return
                }
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    //MARK: 找回密码
    @IBAction func findPassword(_ sender: Any){
        
    }
    
    //MARK: 注册
    @IBAction func register(_ sender: Any){
        
    }
}

//MARK:- textfield delegate
extension LoginVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == accountTextField {
        }else if textField == passwordTextField{
        }
    }
    
    //点击return事件
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0{
            passwordTextField.becomeFirstResponder()
        }else if textField.tag == 1{
            textField.resignFirstResponder()
            login(loginButton)
        }
        return false
    }
    
    /*
    //键盘弹出
    func keyboardWillShow(notif:NSNotification){
        let userInfo = notif.userInfo
        
        let keyboardBounds = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let offset = keyboardBounds.size.height
        
        let animations = {
            let keyboardTransform = CGAffineTransform(translationX: 0, y: -offset)
            self.lowNiavigation.transform = keyboardTransform
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: animations, completion: nil)
        }else{
            animations()
        }
        
    }
    
    //键盘回收
    func keyboardWillHide(notif:NSNotification){
        let userInfo = notif.userInfo
        
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let animations = {
            let keyboardTransform = CGAffineTransform.identity
            self.lowNiavigation.transform = keyboardTransform
        }
        
        if duration > 0 {
            let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            UIView.animate(withDuration: duration, delay: 0, options: options, animations: animations, completion: nil)
        }else{
            animations()
        }
    }
    */
    
    //复制判断
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let existedLength = textField.text?.lengthOfBytes(using: .utf8)
        let selectedLength = range.length
        let replaceLength = string.lengthOfBytes(using: .utf8)
        
        var maxLenght: Int
        if textField.tag == 0{
            maxLenght = accountLength
        }else {
            maxLenght = passwordMaxLength
        }
        
        if existedLength! - selectedLength + replaceLength > maxLenght{
            return false
        }
        
        return true
    }
}
