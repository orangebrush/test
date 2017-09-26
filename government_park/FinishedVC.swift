//
//  FinishedVC.swift
//  government_park
//
//  Created by YiGan on 25/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class FinishedVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var data = ["1", "2", "3"]
    
    //MARK:- init----------------------------------------------------
    override func viewDidLoad() {
        
    }
}

//MARK:- tableview delegate
extension FinishedVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let identifier = "cell0"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! MeCell0
        cell.titleLabel.text = data[row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        //判断状态，选择跳转
        
        let auditingVC = UIStoryboard(name: "Status", bundle: Bundle.main).instantiateViewController(withIdentifier: "auditing") as! AuditingVC
        navigationController?.show(auditingVC, sender: nil)
    }
}
