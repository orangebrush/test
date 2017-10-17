//
//  ListCell.swift
//  government_park
//
//  Created by YiGan on 27/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
import gov_sdk
class ListCell: UITableViewCell {
    
    @IBOutlet weak var markButton: UIButton!
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var originalLabel: UILabel!
    @IBOutlet weak var copyLabel: UILabel!
    @IBOutlet weak var remarksLabel: UILabel!
    
    var applyId = 0
    var attachmentId = 0
    var isChecked = false{
        didSet{
            markButton.isSelected = isChecked
        }
    }
    
    var closure: (()->())?
    
    
    override func didMoveToSuperview() {
        remarksLabel.textColor = .lightGray
    }
    
    @IBAction func click(_ sender: UIButton) {
        isChecked = !isChecked
        NetworkHandler.share().attachment.markStuff(withApplyId: applyId, withStuffId: attachmentId, withMarked: isChecked) { (resultCode, message, data) in
            DispatchQueue.main.async {
                guard resultCode == .success else{
                    return
                }
                self.closure?()
            }
        }
    }
}
