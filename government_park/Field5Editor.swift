//
//  Field5Editor.swift
//  government_park
//
//  Created by YiGan on 20/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//联动编辑器

import UIKit
class Field5Editor: FieldEditor {
    
    fileprivate var maxCount = 0                    //总层级数
    fileprivate var buttonList = [UIButton]()       //按钮数组
    fileprivate var selectedOptionList = [Option](){
        didSet{
            let count = selectedOptionList.count
            print("count:\(count)")
        }
    } //选择的层级数组.count==maxCount
    fileprivate var optionList = [Option]()         //原始数据
    
    //MARK:- init----------------------------------------
    override func viewDidLoad() {
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createContents()
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        
        //判断是否需要拉取数据
        guard optionList.isEmpty else {
            return
        }
        
        NetworkHandler.share().field.pullOptionList(withFieldTypeValue: fieldTypeValue) { (resultCode, message, optionList) in
            DispatchQueue.main.async {
                guard resultCode == .success else{
                    self.notif(withTitle: message, closure: nil)
                    return
                }
                
                var count = 0
                var nextOptionList = optionList
                
                while !nextOptionList.isEmpty{
                    count += 1
                    //print("count: \(count)--\(nextOptionList[0].title)")
                    nextOptionList = nextOptionList[0].optionList
                }
                
                self.maxCount = count
                
                self.optionList = optionList
                self.createButtons()
            }
        }
    }
    
    private func createButtons(){
        for index in (0..<maxCount){
            let buttonFrame = CGRect(x: .edge16, y: CGFloat(index) * (.buttonHeight * 2 + .edge8) + 64 + .edge16, width: view_size.width - .edge16 * 2, height: .buttonHeight * 2)
            let button = UIButton(type: .custom)
            button.frame = buttonFrame
            button.setTitle("请选择\(index + 1)", for: .normal)
            button.backgroundColor = .lightGray
            button.layer.cornerRadius = .cornerRadius
            button.tag = index
            button.addTarget(self, action: #selector(clickField(sender:)), for: .touchUpInside)
            buttonList.append(button)
            view.addSubview(button)
        }
    }
    
    //MARK: 点击选择
    @objc private func clickField(sender: UIButton){
        let tag = sender.tag
        //判断上层button是否已选择
        guard tag - selectedOptionList.count <= 0 else{
            notif(withTitle: "需选择上一级", closure: nil)
            return
        }
        
        //获取上一级选项
        let optList = tag == 0 ? optionList : selectedOptionList[tag - 1].optionList
        
        //跳转到选择器
        let subEditor = storyboard?.instantiateViewController(withIdentifier: "subeditor") as! Field5SubEditor
        subEditor.optionList = optList
        subEditor.closure = {
            option in
            sender.setTitle(option.title, for: .normal)
            sender.backgroundColor = .gray
            
            //重置按钮
            for (index, button) in self.buttonList.enumerated(){
                if index > tag{ //以下按钮重置
                    button.setTitle("请选择\(index + 1)", for: .normal)
                    button.backgroundColor = .lightGray
                }
            }
            
            //移除下层已选择对象
            while self.selectedOptionList.count > tag {
                self.selectedOptionList.removeLast()
            }
            self.selectedOptionList.append(option)
        }
        subEditor.navigationItem.title = tag == 0 ? "中国" : selectedOptionList[tag - 1].title
        navigationController?.show(subEditor, sender: nil)
    }
    
    //MARK: 保存选择
    @IBAction func save(_ sender: Any) {
        
        //判断是否可以保存
        guard maxCount == selectedOptionList.count, maxCount != 0 else {
            self.notif(withTitle: "需选择", closure: nil)
            return
        }
        
        guard let lastOption = selectedOptionList.last else {
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
        let dataDicList = ["id": lastOption.id]
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


