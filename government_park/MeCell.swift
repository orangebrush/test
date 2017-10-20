//
//  MeCell.swift
//  government_park
//
//  Created by YiGan on 25/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit

class MeCell0: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    //MARK:- init--------------------------
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    
    override func draw(_ rect: CGRect) {
        layer.transform = CATransform3DMakeScale(0.9, 0.95, 1)
    }
}

class MeCell1: UITableViewCell {
    
    @IBOutlet weak var checkButton: UIButton!
    
    var closure: (()->())?
    
    @IBAction func click(_ sender: Any){
        closure?()
    }
    
    override func draw(_ rect: CGRect) {
        layer.transform = CATransform3DMakeScale(0.9, 0.95, 1)
    }
}
