//
//  ChangePassword.swift
//  government_park
//
//  Created by YiGan on 18/10/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import Foundation
import gov_sdk
class ChangePasswordVC: UIViewController {
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    private var password: String?
    
    //MARK: 输入
    @IBAction func valueChange(_ sender: UITextField){
        password = sender.text
    }
    
    //MARK: 返回登录页
    @IBAction func back(_ sender: Any){
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: 修改密码
    @IBAction func changePassword(_ sender: Any) {

        password = passwordTextField.text
        let tuple = isPasswordLegal(withString: password)
        
        guard tuple.isLegal else {
            notif(withTitle: tuple.message, closure: nil)
            return
        }
        
        userDefaults.set(password!.sha1(), forKey: "password")
        userDefaults.set(password!, forKey: "originalPassword")
        userDefaults.synchronize()
        
        NetworkHandler.share().account.changePassword(withNewPassword: password!.sha1()) { (resultCode, message, data) in
            DispatchQueue.main.async {
                self.notif(withTitle: message, closure: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

//MARK:- textfield delegate
extension ChangePasswordVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    //点击return事件
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
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
        
        if existedLength! - selectedLength + replaceLength > passwordMaxLength{
            return false
        }
        
        return true
    }
}
