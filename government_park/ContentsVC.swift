//
//  Content.swift
//  government_park
//
//  Created by YiGan on 18/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
import government_sdk

class ContentsVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    //first 新闻数据
    fileprivate var newsPageModel: NewsPageModel?{
        didSet{
            tableView.reloadData()
        }
    }
    
    //second测试数据
    fileprivate var homepagePolicyModelList = [(isOpen: Bool, model: HomepagePolicyModel)](){
        didSet{
            tableView.reloadData()
        }
    }
    
    
    
    //MARK:- init-------------------------------------------------------------------------------------
    override func viewDidLoad() {
        
        config()
        createContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //更新数据
        let newsPageParams = NewsPageParams()
        newsPageParams.page = 1
        newsPageParams.pageSize = 8
        Handler.getPageNews(withParam: newsPageParams){
            resultCode, message, newsPageModel in
            
            guard resultCode == .success else{
                self.notif(withTitle: message, duration: 1, closure: nil)
                return
            }
            
            DispatchQueue.main.async {                
                self.newsPageModel = newsPageModel
            }
        }
        
        Handler.getAllHomepagePolicy{
            resultCode, message, homepagePolicyModelList in
            
            guard resultCode == .success else{
                self.notif(withTitle: message, duration: 1, closure: nil)
                return
            }
            
            DispatchQueue.main.async {
                print("homepagePolicyModelList: \(String(describing: homepagePolicyModelList))")
                
                guard let list = homepagePolicyModelList else{
                    return
                }
                
                self.homepagePolicyModelList.removeAll()
                for model in list{
                    self.homepagePolicyModelList.append((false, model))
                }
            }
        }
    }
    
    private func config() {
        
    }
    
    private func createContents() {
        
    }
}

//MARK:- tableview delegate
extension ContentsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return homepagePolicyModelList.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFrame = CGRect(x: 0, y: 0, width: view_size.width, height: 80)
        let headerView = UIView(frame: headerFrame)
        headerView.backgroundColor = .white
            let labelFrame = CGRect(x: .edge8, y: 0, width: view_size.width - .edge8 * 2, height: 80)
            let label = UILabel(frame: labelFrame)
            label.font = .big
            label.textColor = .word
        headerView.addSubview(label)
        if section == 0{
            label.text = "政策解读"
        }else{
            label.text = "马上开始申报资金"
        }
        
        return headerView
    }
    
    //MARK:- header高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    //MARK:- cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return new_size.height + .edge8 * 2
        }
        
        let tuple = homepagePolicyModelList[indexPath.row]
        
        var text = ""
        for applyto in tuple.model.applyTo{

            text += "扶持对象  \(applyto.target!)\n\(applyto.description!)\n"
        }
        text += "\nzhan wei"
        
        let width = view_size.width - .edge8 * 3 - .buttonHeight * 3
        let size = CGSize(width: width, height: width * 10)
        let rect = NSString(string: text).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.small], context: nil)
    
        let contentHeight: CGFloat = rect.height
        return (view_size.width - .edge8 * 2) * 9 / 16 + 30 + 8 * 3 + (tuple.isOpen ? contentHeight : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        var id: String
        var cell: UITableViewCell
        
        if section == 0 {       //政策解读 cell
            id = "first"
            let firstCell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! FirstCell
            firstCell.data = newsPageModel
            firstCell.closure = {
                newsModel in
                
                //跳转到政策页
                let newsVC = UIStoryboard(name: "Contents", bundle: Bundle.main).instantiateViewController(withIdentifier: "news") as! NewsVC
                newsVC.newsModel = newsModel
                self.navigationController?.show(newsVC, sender: nil)
            }
            cell = firstCell
        }else {                 //马上开始申报资金 cell
            id = "second"

            let secondCell = tableView.dequeueReusableCell(withIdentifier: id) as! SecondCell
            secondCell.index = row
            secondCell.data = homepagePolicyModelList[row]
            secondCell.closure = {
                id in
                
                self.homepagePolicyModelList[id].isOpen = !(self.homepagePolicyModelList[id].isOpen)
                tableView.layoutIfNeeded()
            }
            cell = secondCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0 {       //政策解读 sel
            
        }else {                 //马上开始申报资金 sel
            let model = homepagePolicyModelList[row].model
            let policyVC = UIStoryboard(name: "Policy", bundle: Bundle.main).instantiateViewController(withIdentifier: "policy") as! PolicyVC
            policyVC.id = model.id!
            policyVC.navigationItem.title = model.shortTitle
            navigationController?.show(policyVC, sender: nil)
        }
    }
}
