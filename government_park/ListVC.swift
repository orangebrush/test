//
//  ListVC.swift
//  government_park
//
//  Created by YiGan on 26/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class ListVC: UIViewController {
    
    @IBOutlet weak var neededTableView: UITableView!
    @IBOutlet weak var preparedTableView: UITableView!
    
    private var originY: CGFloat = 0
    private var targetY: CGFloat = 0
    private var isOrigin = false
    
    //MARK:- init-------------------------------------------------------
    override func viewDidLoad() {
        
        //获取偏移位置
        originY = preparedTableView.frame.origin.y
        targetY = view_size.height - 44
        
        //设置圆角
        neededTableView.layer.cornerRadius = .cornerRadius
        preparedTableView.layer.cornerRadius = .cornerRadius
        
        click()
    }
    
    //MARK: 点击header缩放
    @objc fileprivate func click(){
        isOrigin = !isOrigin
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut, animations: {
            self.preparedTableView.frame.origin.y = self.isOrigin ? self.originY : self.targetY
            }) { (completed) in
                
        }
    }
    
    //MARK: 点击已准备好的材料标记
    @IBAction func clickPreparedMark(_ sender: UIButton) {
        
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
            return 12
        }
        return 32
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let tag = tableView.tag
        let headerFrame = CGRect(x: 0, y: 0, width: view_size.width, height: .cellHeight)
        let headerView = UIView(frame: headerFrame)
            let labelFrame = CGRect(x: .edge8, y: 0, width: view_size.width - .edge8, height: .cellHeight)
            let label = UILabel(frame: labelFrame)
            label.text = tag == 0 ? "需要准备的材料" : "已经准备好的材料"
            headerView.addSubview(label)
        
        if tag == 1 {
            let tap = UITapGestureRecognizer(target: self, action: #selector(click))
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            headerView.addGestureRecognizer(tap)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = preparedTableView.dequeueReusableCell(withIdentifier: "cell") as! ListCell
        cell.mainLabel.text = "材料描述"
        cell.originalLabel.text = "材料原件"
        cell.copyLabel.text = "复印件"
        //添加附加链接与附件链接
        cell.remarksLabel.text = "备注信息"
        return cell
    }
}
