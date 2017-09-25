//
//  Field6Editor.swift
//  government_park
//
//  Created by YiGan on 20/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//多选编辑器

import UIKit
class Field6Editor: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var textfieldMap = [Int: UITextField]()
    
    var dataList = [String]()
    var maxLength = 20
    
    //MARK:- init-----------------------------------------
    override func viewDidLoad() {
        
        config()
        createContents()
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        
    }
    
    //MARK: 保存选择
    @IBAction func save(_ sender: Any) {
        
        //获取所选cell
        guard let indexPathList = tableView.indexPathsForSelectedRows else{
            return
        }
        
        let rowList = indexPathList.map{$0.row}
        
    }
}

//MARK:- tableView delegate
extension Field6Editor: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        var cell: UITableViewCell
        cell = tableView.dequeueReusableCell(withIdentifier: "cell!")!
        
        let cell1 = cell as! Field6EditorCell1
        cell1.rowIndex = row
        return cell1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == .none {
            cell?.accessoryType = .checkmark
        }else{
            cell?.accessoryType = .none
        }
    }
}


//MARK:- text field delegate
extension Field6Editor: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let rowIndex = textField.tag
        
        textfieldMap[rowIndex] = textField
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
