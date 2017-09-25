//
//  Group2Cell.swift
//  government_park
//
//  Created by YiGan on 20/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class Group2Cell: GroupCell {
    
    var closure: ((Int)->())?
    
    @objc func click(sender: UIButton){
        closure?(sender.tag)
    }
    
    @IBAction func add(_ sender: Any) {
        closure?(0)
    }
}
