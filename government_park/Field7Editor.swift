//
//  Field7Editor.swift
//  government_park
//
//  Created by YiGan on 30/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class Field7Editor: FieldEditor {
    
    override func viewDidLoad() {
        
        config()
        createContents()
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        
    }
    
    //MARK: 日期修改
    @IBAction func valueChange(_ sender: UIDatePicker){
        let date = sender.date
        
    }
    
    //MARK: 保存
    @IBAction func save(_ sender: Any) {
    }
}
