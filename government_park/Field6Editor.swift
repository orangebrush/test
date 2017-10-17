//
//  Field6Editor.swift
//  government_park
//
//  Created by YiGan on 20/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//多选编辑器

import UIKit
import gov_sdk
class Field6Editor: FieldEditor {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var textfieldMap = [Int: UITextField]()
    
    var valueList = [Value]()
    var maxLength = 20
    
    //MARK:- init-----------------------------------------
    override func viewDidLoad() {
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        createContents()
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        tableView.reloadData()
    }
    
    //MARK: 保存选择
    @IBAction func save(_ sender: Any) {
        
        //获取所选cell
        guard let indexPathList = tableView.indexPathsForSelectedRows else{
            return
        }
        
        let saveFieldParams = SaveFieldParams()
        saveFieldParams.applyId = applyId
        saveFieldParams.componentId = componentId
        saveFieldParams.fieldId = fieldId
        saveFieldParams.instanceId = instanceId
        /*
         简单字段：
         value = '1234';
         单选字段 / 联动单选字段：
         value = '{"id": 1234, "title": "XXXX"}';
         多选字段：
         value = '[{"id": 1234, "title": "XXXX", "extraValue": "2345"}, {"id": 5678, "title": "XXXX", "extraValue": "6789"}]';
         多选字段示例二（可能没有extraValue的情况）：
         value = '[{"id": 1234, "title": "XXXX", "extraValue": "2345"}, {"id": 5678, "title": "XXXX"}]';
         */
        var dataDicList = [[String: Any]]()
        for indexPath in indexPathList{
            var dataDic = [String: Any]()
            let value = valueList[indexPath.row]
            dataDic["id"] = value.id
            dataDic["title"] = value.title ?? ""
            if !value.extraValue.isEmpty{
                let cell1 = tableView.cellForRow(at: indexPath) as! Field6EditorCell1
                dataDic["extraValue"] = cell1.textField.text ?? ""
            }
            dataDicList.append(dataDic)
        }
        let data = try! JSONSerialization.data(withJSONObject: dataDicList, options: .prettyPrinted)
        let valueJson = NSString(data: data, encoding: String.Encoding.utf8.rawValue)
        
        saveFieldParams.value = valueJson
        NetworkHandler.share().field.saveField(withSaveFieldParams: saveFieldParams) { (resultCode, message, data) in
            DispatchQueue.main.async {
                self.notif(withTitle: message, closure: nil)
                guard resultCode == .success else{
                    return
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

//MARK:- tableView delegate
extension Field6Editor: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valueList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let value = valueList[row]
        var cell: UITableViewCell
        if value.extraValue.isEmpty{
            cell = tableView.dequeueReusableCell(withIdentifier: "cell0")!
            let cell0 = cell as! Field6EditorCell0
            cell0.value = value
            return cell0
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "cell1")!
            let cell1 = cell as! Field6EditorCell1
            cell1.value = value
            return cell1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType != .checkmark {
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
