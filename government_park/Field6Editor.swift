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
    
    fileprivate var optionList = [Option]()         //全部列表    
    
    var policyId: Int?
    var valueList = [Value]()                       //已选列表
    
    
    //MARK:- init-----------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        createContents()
    }
    
    private func config(){
        
        tableView.isHidden = true
    }
    
    private func createContents(){
        
        //拉取列表
        if let polId = policyId{
            NetworkHandler.share().field.pullPrizeList(withPolicyId: polId, closure: pullListClosure(_:_:_:))
        }else{
            NetworkHandler.share().field.pullOptionList(withFieldTypeValue: fieldTypeValue, closure: pullListClosure(_:_:_:))
        }
    }
    
    //MARK: 拉取列表回调
    private func pullListClosure(_ resultCode: ResultCode, _ message: String, _ optionList: [Option]){
        DispatchQueue.main.async {
            guard resultCode == .success else{
                self.notif(withTitle: message, closure: nil)
                return
            }
            
            self.optionList = optionList
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
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
            let option = optionList[indexPath.row]
            dataDic["id"] = option.id
            dataDic["title"] = option.title ?? ""
            
            if option.extraField != nil{
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
        return optionList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        let option = optionList[row]
        return option.extraField == nil ? .cellHeight : 88
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let option = optionList[row]
        var cell: UITableViewCell
        
        let filterList = valueList.filter{$0.id == option.id}
        let value = filterList.first
        
        if option.extraField == nil{
            cell = tableView.dequeueReusableCell(withIdentifier: "cell0")!

            let cell0 = cell as! Field6EditorCell0
            cell0.option = option
            return cell0
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "cell1")!
            cell.selectionStyle = .blue
            
            let cell1 = cell as! Field6EditorCell1
            cell1.option = option
            if let val = value{
                cell1.textField.placeholder = val.hint
            }
            return cell1
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType != .checkmark {
            cell?.accessoryType = .checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == .checkmark{
            cell?.accessoryType = .none
        }
    }
}



