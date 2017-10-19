//
//  Field4Editor.swift
//  government_park
//
//  Created by YiGan on 20/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//单选编辑器

import UIKit
class Field4Editor: FieldEditor {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let identifer = "cell"
    
    fileprivate var optionList = [Option]()
    
    //MARK:- init------------------------------------------------------------------
    override func viewDidLoad() {
        
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        createContents()
    }
    
    private func config(){
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identifer)
    }
    
    private func createContents(){
    
        NetworkHandler.share().field.pullOptionList(withFieldTypeValue: fieldTypeValue) { (resultCode, message, optionList) in
            DispatchQueue.main.async {
                guard resultCode == .success else{
                    self.notif(withTitle: message, closure: nil)
                    return
                }
                self.optionList = optionList
                self.tableView.reloadData()
            }
        }
    }

    //MARK: 保存选择
    @IBAction func save(_ sender: Any) {
        //获取所选cell
        guard let indexPathList = tableView.indexPathsForSelectedRows else{
            self.notif(withTitle: "未选取", closure: nil)
            return
        }
        
        guard let indexPath = indexPathList.first else {
            self.notif(withTitle: "只能选择一项", closure: nil)
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
        let option = optionList[indexPath.row]
        let dataDicList: [String: Any] = ["id": option.id, "title": (option.title ?? "")]
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

extension Field4Editor: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifer) ?? UITableViewCell(style: .default, reuseIdentifier: identifer)
        cell.textLabel?.text = optionList[row].title
        return cell
    }
}
