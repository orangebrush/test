//
//  SecondCell.swift
//  government_park
//
//  Created by YiGan on 18/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class SecondCell: UITableViewCell {
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var checkButton: UIButton!
    
    var id: Int = 0
    var data: Bool = false{
        didSet{
            
        }
    }
    
    var closure: ((Int)->())?
    
    //MARK:- init--------------------------------------------
    override func didMoveToSuperview() {
        
        config()
        createContents()
    }
    
    override func draw(_ rect: CGRect) {
        //checkButton.setTitle(data ? "收起" : "展开", for: .normal)
        
        if data {
            let oldButtonFrame = buttonView.frame
            buttonView.frame.origin = CGPoint(x: oldButtonFrame.origin.x, y: rect.height - oldButtonFrame.height - .edge8)
        }
        checkButton.isSelected = data
    }
    
    private func config(){
        
        //添加按钮事件
        checkButton.addTarget(self, action: #selector(check(sender:)), for: .touchUpInside)
    }
    
    private func createContents(){
        
    }
    
    @objc private func check(sender: UIButton){
        closure?(id)
    }
}
