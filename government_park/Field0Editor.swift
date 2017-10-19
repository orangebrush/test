//
//  Field0Editor.swift
//  government_park
//
//  Created by YiGan on 20/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//短文本编辑器

import UIKit
import gov_sdk
class Field0Editor: FieldEditor {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var prefixLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var suffixLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var prefixLabel: UILabel!
    @IBOutlet weak var suffixLabel: UILabel!
    
    //MARK:- init-----------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createContents()
    }
    
    private func config(){

        
    }
    
    private func createContents(){
        
        //maxValue
        if maxValue != nil{
            textField.keyboardType = .decimalPad
        }
        
        //前缀
        if let pre = prefix {
            prefixLabelWidthConstraint.constant = .labelHeight * CGFloat(pre.characters.count)
            prefixLabel.text = pre
            prefixLabel.font = .small
            prefixLabel.textColor = .gray
            textField.textAlignment = .left
        }else{
            prefixLabelWidthConstraint.constant = 0
            prefixLabel.isHidden = true
            textField.textAlignment = .center
        }
        
        //后缀
        if let suf = suffix {
            suffixLabelWidthConstraint.constant = .labelHeight * CGFloat(suf.characters.count)
            suffixLabel.text = suf
            suffixLabel.font = .small
            suffixLabel.textColor = .gray
            textField.textAlignment = .right
        }else{
            suffixLabelWidthConstraint.constant = 0
            suffixLabel.isHidden = true
            textField.textAlignment = .center
        }
    }
    
    //MARK: 保存
    @IBAction func save(_ sender: Any) {
        
        guard let text = textField.text else {
            return
        }
        
        //验证
        if maxValue != nil && !text.isNumber(){
            self.notif(withTitle: "请输入数字", closure: nil)
            return
        }
        
//        //判断大小
//        guard let number = Int(text) else{
//            self.notif(withTitle: "输入错误", closure: nil)
//            return
//        }
//
//        guard number <= maxValue! else {
//            self.notif(withTitle: "超出范围", closure: nil)
//            return
//        }
        
        let saveFieldParams = SaveFieldParams()
        saveFieldParams.applyId = applyId
        saveFieldParams.componentId = componentId
        saveFieldParams.fieldId = fieldId
        saveFieldParams.instanceId = instanceId
        saveFieldParams.value = text
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
