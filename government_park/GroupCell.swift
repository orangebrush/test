//
//  GroupCell.swift
//  government_park
//
//  Created by YiGan on 19/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class GroupCell: UITableViewCell {
    
    var closure: ((Int?)->())?
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    
    //MARK:- init---------------------------
    override func didMoveToSuperview() {
        
        config()
        createContents()
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        
    }
    
    //MARK: 按钮点击
    @IBAction func click(_ sender: UIButton) {
        closure?(sender.tag)
    }
    
    //MARK: view 点击 图片组
    @IBAction func tap(_ sender: UITapGestureRecognizer) {
        closure?(nil)
    }
}
