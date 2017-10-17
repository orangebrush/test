//
//  ListVC.swift
//  government_park
//
//  Created by YiGan on 26/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
import gov_sdk
class ListVC: UIViewController {
    
    @IBOutlet weak var neededTableView: UITableView!
    @IBOutlet weak var preparedTableView: UITableView!
    
    fileprivate var neededStuffList = [Stuff]()         //tag=0
    fileprivate var preparedStuffList = [Stuff]()       //tag=1
    
    fileprivate var tap: UITapGestureRecognizer?
    
    private var originY: CGFloat = 44
    private var targetY: CGFloat = 0
    private var isOrigin = false
    
    var applyId = 0
    
    //MARK:- init-------------------------------------------------------
    override func viewDidLoad() {
        
        config()
        createContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        updateData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //移动一下
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.preparedTableView.frame.origin.y = self.targetY
        }) { (completed) in
            
        }
    }
    
    private func config(){
        
        //设置背景颜色
        view.backgroundColor = .lightGray
        
        //获取偏移位置
        originY = preparedTableView.frame.origin.y + .cellHeight + .edge8
        targetY = view_size.height - 44
        
        //设置圆角
        neededTableView.layer.cornerRadius = .cornerRadius
        preparedTableView.layer.cornerRadius = .cornerRadius
                
    }
    
    private func createContents(){
        
    }
    
    fileprivate func updateData(){
        //获取需要准备的材料列表
        NetworkHandler.share().attachment.getAllStuff(withApplyId: applyId, withDidFinished: false) { (resultCode, message, stuffList) in
            DispatchQueue.main.async {
                guard resultCode == .success else{
                    self.notif(withTitle: message, closure: nil)
                    return
                }
                
                if let list = stuffList{
                    self.neededStuffList.removeAll()
                    self.neededStuffList += list
                    self.neededTableView.reloadData()
                }
                
                //获取已准备的材料列表
                NetworkHandler.share().attachment.getAllStuff(withApplyId: self.applyId, withDidFinished: true, closure: { (resultCode, message, stuffList) in
                    DispatchQueue.main.async {
                        guard resultCode == .success else{
                            self.notif(withTitle: message, closure: nil)
                            return
                        }
                        
                        if let list = stuffList{
                            self.preparedStuffList.removeAll()
                            self.preparedStuffList += list
                            self.preparedTableView.reloadData()
                        }
                    }
                })
            }
        }
    }
    
    //MARK: 点击header缩放
    @objc fileprivate func click(sender: UITapGestureRecognizer){
        let tag = sender.view?.tag
        
        if (isOrigin && tag == 0) || (!isOrigin && tag == 1){
            isOrigin = !isOrigin
        }
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.preparedTableView.frame.origin.y = self.isOrigin ? self.originY : self.targetY
            }) { (completed) in
                
        }
    }
}

//MARK:- tableview delegate
extension ListVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tag = tableView.tag
        
        if tag == 0{
            return neededStuffList.count
        }
        return preparedStuffList.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        let stuff = tableView.tag == 0 ? neededStuffList[row] : preparedStuffList[row]
        
        var height: CGFloat = 189
        height += CGFloat(stuff.attachmentList.count + stuff.markdownList.count) * .buttonHeight + .edge8
        return height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tag = tableView.tag
        let headerFrame = CGRect(x: 0, y: 0, width: view_size.width, height: .cellHeight)
        let headerView = UIView(frame: headerFrame)
        headerView.tag = tag
            let labelFrame = CGRect(x: 0, y: 0, width: view_size.width, height: .cellHeight)
            let label = UILabel(frame: labelFrame)
            label.backgroundColor = tag == 0 ? .red : .green
            label.text = tag == 0 ? " 需要准备的材料" : " 已经准备好的材料"
            headerView.addSubview(label)
        
        
        tap = UITapGestureRecognizer(target: self, action: #selector(click))
        tap?.numberOfTapsRequired = 1
        tap?.numberOfTouchesRequired = 1
        headerView.addGestureRecognizer(tap!)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let stuff = tableView.tag == 0 ? neededStuffList[row] : preparedStuffList[row]
        
        let cell = preparedTableView.dequeueReusableCell(withIdentifier: "cell") as! ListCell
        cell.applyId = applyId
        cell.attachmentId = stuff.id
        cell.isChecked = stuff.checked
        
        cell.mainLabel.text = stuff.title
        cell.originalLabel.text =   "材料原件  " + stuff.original!
        cell.copyLabel.text =       "复印件    " + stuff.copyTitle!
        
        //添加附加链接与附件链接
        let x = cell.copyLabel.frame.origin.x
        var y = cell.copyLabel.frame.origin.y + CGFloat.labelHeight * 2 + CGFloat.edge8
        let width = cell.frame.width - x - .edge8
        let height = CGFloat.labelHeight
        for (index, markdown) in stuff.markdownList.enumerated(){         //附件链接
            let buttonFrame = CGRect(x: x, y: y, width: width, height: height)
            let button = UIButton(type: .custom)
            button.frame = buttonFrame
            button.tag = markdown.id
            //markdown.title
            button.setTitle("附加链接\(index + 1)", for: .normal)
            button.setTitleColor(.blue, for: .normal)
            cell.addSubview(button)
            y += .buttonHeight
        }
        for (index, attachment) in stuff.attachmentList.enumerated(){     //附件
            let buttonFrame = CGRect(x: x, y: y, width: width, height: height)
            let button = UIButton(type: .custom)
            button.frame = buttonFrame
            button.tag = attachment.id
            button.setTitle("附件\(index + 1)", for: .normal)
            button.setTitleColor(.blue, for: .normal)
            cell.addSubview(button)
            y += .buttonHeight
        }
        cell.remarksLabel.text = stuff.detailTitle
        cell.closure = {
            self.updateData()
        }
        cell.sizeToFit()
        return cell
    }
}
