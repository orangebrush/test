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
    
    var option: Option?{
        didSet{
            guard let opt = option else {
                return
            }
            label.text = opt.title
        }
    }
}

class Field6EditorCell1: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var suffixLabel: UILabel!
    @IBOutlet weak var suffixWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var textField: UITextField!
    
    var option: Option?{
        didSet{
            guard let opt = option else {
                return
            }

            if let extraField = opt.extraField{
                titleLabel.text = extraField.title
                titleLabel.font = .small
                titleLabel.textColor = .gray
                
                if let suffix = extraField.suffix{
                    suffixLabel.text = extraField.suffix
                    suffixLabel.font = .small
                    suffixLabel.textColor = .gray
                    suffixWidthConstraint.constant = 21 * CGFloat(suffix.characters.count)
                }else{
                    suffixWidthConstraint.constant = 0
                }
            }else{
                titleLabel.isHidden = true
                suffixLabel.isHidden = true
                textField.isHidden = true
            }
            label.text = opt.title
        }
    }
}
