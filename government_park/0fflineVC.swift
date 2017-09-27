//
//  SatusVC.swift
//  government_park
//
//  Created by YiGan on 25/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//已进入线下办理

import UIKit
class OfflineVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var text: String?
    
    
    //MARK:- init-----------------------------------------------------
    override func viewDidLoad() {
        
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        createContents()
    }
    
    private func config(){
        scrollView.backgroundColor = .gray
    }
    
    private func createContents(){
        
        let width = view_size.width - .edge8 * 2
        
        //提示
        let label0Frame = CGRect(x: .edge8, y: .edge8, width: width, height: .labelHeight)
        let label0 = UILabel(frame: label0Frame)
        label0.text = "恭喜你通过了线上审核!"
        scrollView.addSubview(label0)
        
        //动态标签
        let label1Frame = CGRect(x: .edge8, y: label0Frame.origin.y + label0Frame.height + .edge8, width: width, height: .labelHeight * 5)
        let label1 = UILabel(frame: label1Frame)
        label1.text = text
        scrollView.addSubview(label1)
        label1.sizeToFit()
        
        //地图
        let imageLength = width / 2 - .edge8
        let imageFrame = CGRect(x: .edge8, y: label1Frame.origin.y + label1.frame.height + .edge8, width: imageLength, height: imageLength)
        let imageView = UIImageView(frame: imageFrame)
        scrollView.addSubview(imageView)
        
        //地址
        let label2Frame = CGRect(x: view_size.width / 2, y: imageFrame.origin.y, width: imageLength, height: imageLength)
        let label2 = UILabel(frame: label2Frame)
        label2.textAlignment = .center
        label2.text = "address"
        scrollView.addSubview(label2)
        
        //材料清单文字
        let label3Frame = CGRect(x: .edge8, y: imageFrame.origin.y + imageLength + .edge8 * 3, width: width, height: 100)
        let label3 = UILabel(frame: label3Frame)
        label3.text = "在你前往政府时，务必带齐材料 清单中的所有材料。清单中的每 一项材料都有详细的要求，严格 按照要求来准备，就能确保你的 材料齐全且符合规范。"
        scrollView.addSubview(label3)
        label3.sizeToFit()
        
        //材料清单按钮
        let buttonFrame = CGRect(x: .edge8, y: label3Frame.origin.y + label3.frame.height + .edge8, width: width, height: .edge8 + .labelHeight + .edge8 + .labelHeight + .edge8 + .labelHeight + .edge8)
        let buttonView = UIView(frame: buttonFrame)
        buttonView.layer.cornerRadius = .cornerRadius
        buttonView.backgroundColor = .white
        let subLabel0Frame = CGRect(x: 0, y: 0, width: width, height: buttonFrame.height * 2 / 3)
        let subLabel0 = UILabel(frame: subLabel0Frame)
        subLabel0.text = "准备材料完成度: 0%"
        subLabel0.textAlignment = .center
        buttonView.addSubview(subLabel0)
        let subLabel1Frame = CGRect(x: 0, y: buttonFrame.height * 2 / 3, width: width, height: buttonFrame.height / 3)
        let subLabel1 = UILabel(frame: subLabel1Frame)
        subLabel1.text = "进入材料清单>"
        subLabel1.textAlignment = .center
        buttonView.addSubview(subLabel1)
        scrollView.addSubview(buttonView)
        
        //点击手势 完善材料清单
        let tap0 = UITapGestureRecognizer(target: self, action: #selector(click(_:)))
        tap0.numberOfTapsRequired = 1
        tap0.numberOfTouchesRequired = 1
        buttonView.addGestureRecognizer(tap0)
        
        
        //联系人文字
        let label4Frame = CGRect(x: .edge8, y: buttonFrame.origin.y + buttonFrame.height, width: width, height: 100)
        let label4 = UILabel(frame: label4Frame)
        label4.text = "联络你的政府联络人，确定或调整办理时间，或询问细节。"
        scrollView.addSubview(label4)
        label4.sizeToFit()
        
        //联系人按钮
        let contactFrame = CGRect(x: .edge8, y: label4Frame.origin.y + label4.frame.height + .edge8, width: width, height: .edge8 + .labelHeight + .edge8 + .labelHeight + .edge8)
        let contactView = UIView(frame: contactFrame)
        contactView.backgroundColor = .white
        contactView.layer.cornerRadius = .cornerRadius
        let subLabel2Frame = CGRect(x: 0, y: .edge8, width: width, height: .labelHeight)
        let subLabel2 = UILabel(frame: subLabel2Frame)
        subLabel2.text = "name"
        contactView.addSubview(subLabel2)
        let subLabel3Frame = CGRect(x: 0, y: subLabel2Frame.origin.y + subLabel2Frame.height + .edge8, width: width, height: .labelHeight)
        let subLabel3 = UILabel(frame: subLabel3Frame)
        subLabel3.text = "电话： "
        contactView.addSubview(subLabel3)
        scrollView.addSubview(contactView)
        
        //点击手势 拨打联系电话
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(call(_:)))
        tap1.numberOfTouchesRequired = 1
        tap1.numberOfTapsRequired = 1
        contactView.addGestureRecognizer(tap1)
    }
    
    //MARK: 点击进入完善材料清单
    @objc private func click(_ tap: UITapGestureRecognizer){
        
        let listVC = UIStoryboard(name: "List", bundle: Bundle.main).instantiateViewController(withIdentifier: "list")
        navigationController?.show(listVC, sender: nil)
    }
    
    //MARK: 点击拨打联系人电话
    @objc private func call(_ tap: UITapGestureRecognizer){
        guard let url = URL(string: "tel://10086") else {
            return
        }
        UIApplication.shared.openURL(url)
    }
}
