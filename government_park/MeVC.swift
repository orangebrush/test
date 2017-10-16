//
//  MeVC.swift
//  government_park
//
//  Created by YiGan on 18/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
import gov_sdk
class MeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    //状态列表
    fileprivate var applyStatusListList: [[ApplyStatus]] = [
        [.undetermined, .reservation],                                      //已进入线下办理环节
        [.unread, .untreated, .interested, .notConsider],                   //审核中
        [.initial, .editing, .waiting],                                     //填写在线申请材料
        [.reject, .approval, .refuse, .overdue, .underCarriage, .black, .interrupt]    //已完结
    ]
    
    //所有申请map
    fileprivate var applyListMap = [ApplyStatus: [Apply]]()
    //所有申请list
    fileprivate var applyListList = Array(repeating: [Apply](), count: 4)
    
    //所有收藏申请
    fileprivate var bookmarkPolicyList = [Policy]()
    
    
    
    
    
    //MARK:- init----------------------------------------------
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //获取申请列表
        NetworkHandler.share().me.getAllApply { (resultCode, message, applyList) in
            DispatchQueue.main.async {
                guard resultCode == .success else{
                    self.notif(withTitle: message, duration: 3, closure: nil)
                    self.login()
                    return
                }
                
                guard let aplList = applyList else{
                    self.notif(withTitle: message, duration: 3, closure: nil)
                    return
                }
                
                self.applyListMap.removeAll()
                
                //存储申请列表
                for apply in aplList{
                    if let status = apply.applyStatus{
                        if self.applyListMap[status] == nil{
                            self.applyListMap[status] = [Apply]()
                            //index += 1
                        }
                        
                        self.applyListMap[status]?.append(apply)

                        let index: Int
                        switch status{
                        case let sta where self.applyStatusListList[0].contains(sta):
                            index = 0
                        case let sta where self.applyStatusListList[1].contains(sta):
                            index = 1
                        case let sta where self.applyStatusListList[2].contains(sta):
                            index = 2
                        default:
                            index = 3
                        }
                        self.applyListList[index].append(apply)
                        self.tableView.reloadData()
                    }
                }
                
                //获取收藏列表
                NetworkHandler.share().me.getBookmarkPolicy { (resultCode, message, policyList) in
                    DispatchQueue.main.async {
                        guard let list = policyList else{
                            self.notif(withTitle: message, duration: 3, closure: nil)
                            return
                        }
                        
                        self.bookmarkPolicyList = list
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    //MARK: 个人设置
    @IBAction func setting(_ sender: Any) {
        
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "修改密码", "退出登录")
        actionSheet.show(in: view)
    }
}

//MARK:- tableview delegate
extension MeVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4 + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:             //已进入线下环节
            let list = getApplyList(fromApplyListMap: applyListMap, withApplyStatus: [.undetermined, .reservation])
            return list.count
        case 1:             //审核中
            let list = getApplyList(fromApplyListMap: applyListMap, withApplyStatus: [.unread, .untreated, .interested, .notConsider])
            return list.count
        case 2:             //填写在线申请资料
            let list = getApplyList(fromApplyListMap: applyListMap, withApplyStatus: [.initial, .editing, .waiting])
            return list .count
        case 3:             //收藏
            return bookmarkPolicyList.count
        default:            //已完结（按钮入口）
            return 1
        }
    }
    
    //MARK: 通过状态获取申请列表(排除企业主动取消的情况)
    func getApplyList(fromApplyListMap applyListMap: [ApplyStatus: [Apply]], withApplyStatus applyStatusList: [ApplyStatus]) -> [Apply]{
        var resultList = [Apply]()
        for (applyStatus, applyList) in applyListMap{
            if applyStatusList.contains(applyStatus){
                let list = applyList.filter{$0.instanceStatus == InstanceStatus.normal}
                resultList += list
            }
        }
        return resultList
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "已进入线下办理环节"
        case 1:
            return "审核中"
        case 2:
            return "填写在线申请材料"
        case 3:
            return "收藏"
        case 4:
            return " "
        default:
            return "other"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let identifier: String
        var cell: UITableViewCell
        
        switch section {
        case 4:           //已完结 按钮
            identifier = "cell1"
            let cell1 = tableView.dequeueReusableCell(withIdentifier: identifier) as! MeCell1
            cell1.checkButton.setTitle("查看已完结的申请", for: .normal)
            cell1.closure = {
                //点击查看已完结回调
                let finishedVC = UIStoryboard(name: "Finished", bundle: Bundle.main).instantiateViewController(withIdentifier: "finished") as! FinishedVC
                finishedVC.applyList = self.applyListList[3]
                self.navigationController?.show(finishedVC, sender: nil)
            }
            cell = cell1
        case 3:         //收藏
            identifier = "cell0"
            let policy = bookmarkPolicyList[row]
            
            let cell0 = tableView.dequeueReusableCell(withIdentifier: identifier) as! MeCell0
            cell0.titleLabel.text = policy.shortTitle
            cell0.subTitleLabel.text = policy.date?.hint()
            cell0.detailLabel.text = "扶持对象: " + policy.applicantList[0].name! + " 等\(policy.applicantList.count)个"
            cell = cell0
        default:
            identifier = "cell0"
            let apply = applyListList[section][row]
            
            let cell0 = tableView.dequeueReusableCell(withIdentifier: identifier) as! MeCell0
            cell0.titleLabel.text = apply.policyShortTitle
            cell0.subTitleLabel.text = apply.dateHint
            cell0.detailLabel.text = apply.statusHint
            cell = cell0
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        let progressType = ProgressType(rawValue: section)! //ProgressType.editing 0 1 2 3 4
        
        switch progressType {
        case .offline:              //已进入线下办理
            //跳转到线下页(offline)
            let apply = applyListList[section][row]
            let offlineVC = UIStoryboard(name: "Status", bundle: Bundle.main).instantiateViewController(withIdentifier: "offline") as! OfflineVC
            offlineVC.apply = apply
            navigationController?.show(offlineVC, sender: nil)
        case .auditing:             //审核中
            //跳转到申请状态页(auditing)
            let apply = applyListList[section][row]
            let auditingVC = UIStoryboard(name: "Status", bundle: Bundle.main).instantiateViewController(withIdentifier: "auditing") as! AuditingVC
            auditingVC.apply = apply
            navigationController?.show(auditingVC, sender: nil)
        case .editing:              //编辑资料
            //跳转到申请编辑器(editing)
            let apply = applyListList[section][row]
            let editVC = UIStoryboard(name: "Edit", bundle: Bundle.main).instantiateViewController(withIdentifier: "edit") as! EditVC
            editVC.isRootEdit = true
            editVC.apply = apply
            editVC.navigationItem.title = apply.policyShortTitle
            editVC.policyId = apply.policyId
            
            navigationController?.show(editVC, sender: nil)
        case .collected:            //收藏
            //跳转到政策详情页(collected)
            let policy = bookmarkPolicyList[row]
            
            let policyVC = UIStoryboard(name: "Policy", bundle: Bundle.main).instantiateViewController(withIdentifier: "policy") as! PolicyVC
            policyVC.id = policy.id
            policyVC.navigationItem.title = policy.shortTitle
            navigationController?.show(policyVC, sender: nil)
        default:
            //已完结 通过button回调实现(此处不做处理)
            break
        }
        
        
    }
}

//MARK:- action sheet delegate
extension MeVC: UIActionSheetDelegate{
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            print("click 取消")
        case 1:
            print("click 修改密码")
        case 2:
            print("click 退出登录")
        default:
            print("click other")
        }
    }
}


