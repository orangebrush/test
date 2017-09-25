//
//  Field6EditorCell.swift
//  government_park
//
//  Created by YiGan on 21/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class Field6EditorCell0: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
}

class Field6EditorCell1: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var rowIndex: Int = 0{
        didSet{
            textField.tag = tag
        }
    }
}
