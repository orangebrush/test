//
//  PolicyCheckVC.swift
//  government_park
//
//  Created by YiGan on 20/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
import gov_sdk
class PolicyCheckVC: UIViewController {
    
    
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var policy: Policy?
    
    //MARK:- init-------------------------------------
    override func viewDidLoad() {
        
        config()
        createContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func config(){
        closeButton.layer.cornerRadius = .cornerRadius
    }
    
    private func createContents(){
        
    }
    
    @IBAction func close(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

//MARK:- tableview delegate
extension PolicyCheckVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let pol = policy else {
            return 0
        }
        
        switch section {
        case 0:         //短标题
            return 1
        case 1:         //扶持对象
            return pol.applicantList.count
        case 2:         //1正文内容
            return pol.documentList.count + pol.prizeList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
        case 0:         //标题
            return 44 * 2
        case 1:         //扶持对象
            let applicant = (policy?.applicantList)?[row]
            
            let text = applicant?.detailText ?? ""
            let size = CGSize(width: view_size.width, height: view_size.width)
            let rect = NSString(string: text).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont(name: UIFont.mainName, size: .labelHeight)!], context: nil)
            
            
            return .edge8 + .labelHeight + .edge8 + rect.height + .edge8
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        var identifier = ""
        
        var cell: UITableViewCell
        
        switch section {
        case 0:     //标题
            identifier = "single"
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "single") as! PolicySingleLineCell
            singleCell.label.text = policy?.longTitle
            cell = singleCell
        case 1:     //扶持对象
            let muteCell = tableView.dequeueReusableCell(withIdentifier: "mute") as! PolicyMuteLineCell
            if let applicant = (policy?.applicantList)?[row]{
                muteCell.titleLabel.text = "扶持对象  " + applicant.name!
                muteCell.detailLabel.text = applicant.detailText
            }
            cell = muteCell
        case 2:     //正文内容
            let muteCell = tableView.dequeueReusableCell(withIdentifier: "mute") as! PolicyMuteLineCell
            if let document = (policy?.documentList)?[row]{
                muteCell.titleLabel.text = document.title
            }
            cell = muteCell
        default:
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        return cell
    }
}
