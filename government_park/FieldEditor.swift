//
//  FieldEditor.swift
//  government_park
//
//  Created by YiGan on 16/10/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
import gov_sdk
class FieldEditor: UIViewController {
    var applyId = 0
    var componentId = 0
    var fieldId = 0
    var instanceId: Int?
    
    var fieldTypeValue = 0          //字段类型具体值
    
    var maxLength = 500
    var maxValue: Int?
    
    var suffix: String?
    var prefix: String?
    
    override func viewDidLoad() {
        //键盘事件
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notif:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notif:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK:- 复制判断
    @IBAction func valueChanged(_ sender: UITextField) {
        guard sender.text != nil else{
            return
        }
        
        //限制字符数
        if (sender.text?.lengthOfBytes(using: String.Encoding.utf8))! > maxLength{
            while sender.text!.lengthOfBytes(using: String.Encoding.utf8) > maxLength {
                
                let endIndex = sender.text!.index(sender.text!.endIndex, offsetBy: -1)
                let range = Range(sender.text!.startIndex..<endIndex)
                sender.text = sender.text!.substring(with: range)
            }
        }
    }
}

//MARK:- text field delegate
extension FieldEditor: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //let rowIndex = textField.tag
        
        //textfieldMap[rowIndex] = textField
    }
    
    //点击return事件
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    //键盘弹出
    func keyboardWillShow(notif:NSNotification){
        let userInfo = notif.userInfo
        
        let keyboardBounds = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let offset = keyboardBounds.size.height
        
        /*
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
         */
    }
    
    //键盘回收
    func keyboardWillHide(notif:NSNotification){
        let userInfo = notif.userInfo
        
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        /*
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
         */
    }
    
    //复制判断
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let existedLength = textField.text?.lengthOfBytes(using: .utf8)
        let selectedLength = range.length
        let replaceLength = string.lengthOfBytes(using: .utf8)
        
        if existedLength! - selectedLength + replaceLength > maxLength{
            return false
        }
        
        return true
    }
}
