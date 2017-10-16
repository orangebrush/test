//
//  Field5Editor.swift
//  government_park
//
//  Created by YiGan on 20/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//联动编辑器

import UIKit
class Field5Editor: FieldEditor {
    
    fileprivate var selectedData: String?
    
    var dataList = [[String]]()
    
    //MARK:- init----------------------------------------
    override func viewDidLoad() {
        
        config()
        createContents()
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        
        //创建条目
        for (index, datas) in dataList.enumerated(){
            let buttonFrame = CGRect(x: .edge16, y: CGFloat(index) * (.buttonHeight + .edge8), width: view_size.width - .edge16 - .edge8, height: .buttonHeight)
            let button = UIButton(frame: buttonFrame)
            button.setTitle(datas.first, for: .normal)
            button.tag = index
            button.addTarget(self, action: #selector(clickField(sender:)), for: .touchUpInside)
            view.addSubview(button)
        }
    }
    
    //MARK: 点击选择
    @objc private func clickField(sender: UIButton){
        let tag = sender.tag
        
        let data = dataList[tag]
        
        //跳转到选择器
        let subEditor = storyboard?.instantiateViewController(withIdentifier: "subeditor") as! Field5SubEditor
        subEditor.dataList = data
        subEditor.closure = {
            index, data in
            sender.setTitle(data, for: .normal)
        }
        navigationController?.show(subEditor, sender: nil)
    }
    
    //MARK: 保存选择
    @IBAction func save(_ sender: Any) {
        
        guard let selData = selectedData else {
            return
        }
    }
}


