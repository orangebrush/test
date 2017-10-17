//
//  Field6EditorCell.swift
//  government_park
//
//  Created by YiGan on 21/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
import gov_sdk
class Field6EditorCell0: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    var value: Value?{
        didSet{
            guard let val = value else {
                return
            }
            label.text = val.title
        }
    }
}

class Field6EditorCell1: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    var value: Value?{
        didSet{
            guard let val = value else {
                return
            }
            if val.extraValue.isEmpty{
                textField.isHidden = true
            }
            label.text = val.title
        }
    }
}
