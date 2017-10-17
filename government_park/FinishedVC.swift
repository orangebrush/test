//
//  FinishedVC.swift
//  government_park
//
//  Created by YiGan on 25/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
import gov_sdk
class FinishedVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var applyList = [Apply]()
    
    //MARK:- init----------------------------------------------------
    override func viewDidLoad() {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}

//MARK:- tableview delegate
extension FinishedVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return applyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let identifier = "cell0"
        
        let apply = applyList[row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! MeCell0
        cell.titleLabel.text = apply.policyShortTitle
        cell.subTitleLabel.text = apply.dateHint
        cell.detailLabel.text = apply.statusHint
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
        //判断状态，选择跳转
        
        let auditingVC = UIStoryboard(name: "Status", bundle: Bundle.main).instantiateViewController(withIdentifier: "auditing") as! AuditingVC
        auditingVC.applyId = applyList[row].id
        navigationController?.show(auditingVC, sender: nil)
    }
}
