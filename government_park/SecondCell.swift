//
//  SecondCell.swift
//  government_park
//
//  Created by YiGan on 18/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
import government_sdk
class SecondCell: UITableViewCell {
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var checkButton: UIButton!
    
    var index: Int = 0
    var data: (isOpen: Bool, model: HomepagePolicyModel)?
    
    var closure: ((Int)->())?
    
    //MARK:- init--------------------------------------------
    override func didMoveToSuperview() {
        
        config()
        createContents()
    }
    
    override func draw(_ rect: CGRect) {
        guard let d = data else{
            return
        }
        
        if d.isOpen {
            let oldButtonFrame = buttonView.frame
            buttonView.frame.origin = CGPoint(x: oldButtonFrame.origin.x, y: rect.height - oldButtonFrame.height - .edge8)
        }
        checkButton.isSelected = d.isOpen
        
        //更新内容
        let model = d.model
        if let url = URL(string: model.smallPic){
            do{
                let imageData = try Data(contentsOf: url)
                let image = UIImage(data: imageData)
                backImageView.image = image
            }catch {}
        }
        imageLabel.text = model.shortTitle
        
        //扶持对象
        if d.isOpen {
            var text = ""
            for applyTo in model.applyTo{
                text += "扶持对象  \(applyTo.target!)\n\(applyTo.description!)\n"
            }
            titleLabel.text = text
        }else{
            titleLabel.text = "扶持对象  " + model.applyTo.first!.target + "  等\(model.applyTo.count)项"
        }
    }
    
    private func config(){
        
        //添加按钮事件
        checkButton.addTarget(self, action: #selector(check(sender:)), for: .touchUpInside)
        
        //初始化设置
        imageLabel.textColor = .white
        titleLabel.font = .small
    }
    
    private func createContents(){
        
    }
    
    @objc private func check(sender: UIButton){
        closure?(index)
    }
}
