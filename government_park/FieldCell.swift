//
//  FieldCell.swift
//  government_park
//
//  Created by YiGan on 20/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class FieldCell: UITableViewCell {

    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    //MARK:- init
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        config()
        createContents()
    }
    
    private func config(){
        firstLabel.font = .middle
        secondLabel.font = .small
//        secondLabel.textColor = .gray
    }
    
    private func createContents(){
        
    }
}
