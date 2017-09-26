//
//  MeVC.swift
//  government_park
//
//  Created by YiGan on 18/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit

class MeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK:- init----------------------------------------------
    override func viewDidLoad() {
        
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
        case 4:
            return 1
        default:
            return 2
        }
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
        let identifier = section == 4 ? "cell1" : "cell0"
        var cell: UITableViewCell
        
        switch section {
        case 4:
            let cell1 = tableView.dequeueReusableCell(withIdentifier: identifier) as! MeCell1
            cell1.closure = {
                //点击查看已完结回调
                let finishedVC = UIStoryboard(name: "Finished", bundle: Bundle.main).instantiateViewController(withIdentifier: "finished")
                self.navigationController?.show(finishedVC, sender: nil)
            }
            cell = cell1
        default:
            let cell0 = tableView.dequeueReusableCell(withIdentifier: identifier) as! MeCell0
            cell0.titleLabel.text = "title"
            cell0.subTitleLabel.text = "subTitle \(row)"
            cell0.detailLabel.text = "detail"
            cell = cell0
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        let progressType = ProgressType(rawValue: section)! //ProgressType.editing
        
        switch progressType {
        case .offline:
            //跳转到线下页(offline)
            let offlineVC = UIStoryboard(name: "Status", bundle: Bundle.main).instantiateViewController(withIdentifier: "offline") as! OfflineVC
            navigationController?.show(offlineVC, sender: nil)
        case .auditing:
            //跳转到申请状态页(auditing)
            let auditingVC = UIStoryboard(name: "Status", bundle: Bundle.main).instantiateViewController(withIdentifier: "auditing") as! AuditingVC
            navigationController?.show(auditingVC, sender: nil)
        case .editing:
            //跳转到申请编辑器(editing)
            let editVC = UIStoryboard(name: "Edit", bundle: Bundle.main).instantiateViewController(withIdentifier: "edit")
            navigationController?.show(editVC, sender: nil)
        case .collected:
            //跳转到政策详情页(collected)
            let policyVC = UIStoryboard(name: "Policy", bundle: Bundle.main).instantiateViewController(withIdentifier: "policy")
            navigationController?.show(policyVC, sender: nil)
        default:
            //已完结 通过button回调实现
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


