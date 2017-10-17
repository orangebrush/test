//
//  SecondCell.swift
//  government_park
//
//  Created by YiGan on 18/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
import gov_sdk
class SecondCell: UITableViewCell {
    
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var imageLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonView: UIView!
    @IBOutlet weak var checkButton: UIButton!
    
    var index: Int = 0
    var policyTuple: (isOpen: Bool, policy: Policy)?{
        didSet{
            layoutIfNeeded()
            
        }
    }
    
    var closure: ((Int)->())?
    
    //MARK:- init--------------------------------------------
    override func didMoveToSuperview() {
        
        config()
        createContents()
    }        
    
    static var i = 0
    override func layoutIfNeeded() {
        
        guard let tuple = policyTuple else{
            return
        }
        SecondCell.i += 1
        print("----\(SecondCell.i)")
        if tuple.isOpen {
            let oldButtonFrame = buttonView.frame
            buttonView.frame.origin = CGPoint(x: oldButtonFrame.origin.x, y: frame.height - oldButtonFrame.height - .edge8)
        }
        checkButton.isSelected = tuple.isOpen
        
        //更新内容
        let policy = tuple.policy
        DispatchQueue.global().async {
            if let url = policy.smallPicUrl{
                do{
                    let imageData = try Data(contentsOf: url)
                    let image = UIImage(data: imageData)
                    DispatchQueue.main.async {
                        self.backImageView.image = image
                    }
                }catch {}
            }
        }
        imageLabel.text = policy.shortTitle
        
        //扶持对象
        if tuple.isOpen {
            var text = ""
            for applicant in policy.applicantList{
                text += "扶持对象  \(applicant.name!)\n\(applicant.detailText!)\n"
            }
            titleLabel.text = text
        }else{
            titleLabel.text = "扶持对象  " + policy.applicantList.first!.name! + "  等\(policy.applicantList.count)项"
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
