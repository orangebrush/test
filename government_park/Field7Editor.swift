//
//  Field7Editor.swift
//  government_park
//
//  Created by YiGan on 30/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class Field7Editor: FieldEditor {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    private var timeInterval: TimeInterval?
    
    override func viewDidLoad() {
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createContents()
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        datePicker.setDate(Date(), animated: true)
    }
    
    //MARK: 日期修改
    @IBAction func valueChange(_ sender: UIDatePicker){
        let date = sender.date
        
        timeInterval = date.timeIntervalSince1970
    }
    
    //MARK: 保存
    @IBAction func save(_ sender: Any) {
        
        guard let interval = timeInterval else {
            return
        }
        
        let longInterval = Int(interval * 1000)
        
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
        
        saveFieldParams.value = "\(longInterval)"
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
