//
//  Policy.swift
//  government_park
//
//  Created by YiGan on 19/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
import gov_sdk
class PolicyVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var collectionButton: UIButton!
    private let ganAlert = GANAlertAction()
    
    
    private var image: UIImage?{
        didSet{
            
        }
    }
    
    //政策
    fileprivate var policy: Policy?{
        didSet{
            guard let pol = policy else {
                return
            }            
            
            //是否可收藏
            NetworkHandler.share().policy.isPolicyBookmarked(withPolicyId: pol.id) { (resultCode, message, isBookmarked) in
                
                DispatchQueue.main.async {
                    guard resultCode == .success else{
                        self.notif(withTitle: message, closure: nil)
                        return
                    }
                    self.collectionButton.isEnabled = true
                    self.collectionButton.isHidden = false
                    self.collectionButton.isSelected = isBookmarked
                }
            }
            
            tableView.reloadData()
        }
    }
    
    //申请
    fileprivate var apply: Apply?{
        didSet{
            guard let apl = apply else {
                return
            }
            
            //判断是否已申请
            /*
             case initial = 10           //新建
             case editing = 11           //填写中
             case waiting = 18           //待提交
             //}
             //public enum Committed: Int{             //已提交
             case unread = 20            //未阅读
             case untreated = 21         //未处理
             case interested = 22        //感兴趣
             case notConsider = 23       //不考虑
             case reject = 29            //驳回
             //}
             //public enum BelowLine: Int{             //已进入线下环节
             case undetermined = 30      //尚未确定办理时间
             case reservation = 31       //已预约办理
             case approval = 38          //批准拨款
             case refuse = 39            //拒绝拨款
             //}
             //public enum Interrupt: Int{             //中断
             case overdue = 40           //政策自动过期
             case underCarriage = 41     //政策强行下架
             case black = 42             //企业被拉黑
             case interrupt = 49         //强行中断
             */
            switch apl.applyStatus! {
            case .initial, .editing, .waiting :
                applyButton.setTitle("继续编辑\(apl.finished)%", for: .normal)
            case .unread, .untreated, .interested, .notConsider, .reject:
                applyButton.setTitle("查看申请", for: .normal)  //提交线下申请材料（完成度）
            case .undetermined, .reservation, .approval, .refuse:
                applyButton.setTitle("申请已拒绝", for: .normal)
            default:
                applyButton.setTitle("申请已中断", for: .normal)
            }
        }
    }
    
    //政策id
    var id = 0
    
    //申请id
    var applyId: Int?
    
    
    //MARK:- init--------------------------------------------------
    override func viewDidLoad() {
        
        config()
        createContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.isNavigationBarHidden = false
        
        //获取政策详情
        NetworkHandler.share().policy.getPolicy(withPolicyId: id) { (resultCode, message, policy) in

            DispatchQueue.main.async {
                guard resultCode == .success else{
                    self.notif(withTitle: message, duration: 1, closure: nil)
                    return
                }
                
                self.policy = policy
                //判断是否有该申请 then 获取申请
                NetworkHandler.share().policy.existedApply(withPolicyId: self.id, closure: { (resultCode, message, apply) in
                    DispatchQueue.main.async {
                        guard resultCode == .success else{  //登陆判断
                            self.login()
                            return
                        }
                        
                        self.tableView.isHidden = false
                        
                        guard let apl = apply else{
                            //新建申请
                            //NetworkHandler.share().policy.addApply(withPolicyId: self.id, closure: self.getApplyClosure(resultCode:message:apply:))
                            self.applyButton.isEnabled = true
                            return
                        }
                        
                        //获取已有申请
                        NetworkHandler.share().status.getApply(withApplyId: apl.id, closure: self.getApplyClosure(resultCode:message:apply:))
                    }
                })
            }
        }
    }
    
    //MARK:- 获取到申请目录后回调
    private func getApplyClosure(resultCode: ResultCode, message: String, apply: Apply?){
        DispatchQueue.main.async {
            guard resultCode == .success else {
                //self.notif(withTitle: message, closure: nil)
                return
            }
            guard let apl = apply else{
                return
            }
            
            self.applyButton.isEnabled = true
            self.applyId = apl.id
            self.apply = apl
        }
    }
    
    private func config(){
        
        automaticallyAdjustsScrollViewInsets = false
        
        collectionButton.isHidden = true
        applyButton.setTitle("申请", for: .normal)
        applyButton.isEnabled = false
        
        tableView.isHidden = true
    }
    
    private func createContents(){
        
        view.addSubview(ganAlert)
    }
    
    //MARK: 收藏
    @IBAction func collection(_ sender: UIButton) {

        let isSelected = sender.isSelected
        collectionButton.isEnabled = false
        NetworkHandler.share().policy.bookmarkPolicy(withPolicyId: id, isBookmark: !isSelected) { (resultCode, message, dataf) in
            DispatchQueue.main.async {
                self.notif(withTitle: message, closure: nil)
                self.collectionButton.isEnabled = true
                self.collectionButton.isSelected = !isSelected
                guard resultCode == .success else{
                    return
                }
            }
        }
        collectionButton.isSelected = !collectionButton.isSelected
    }
    
    //MARK:- 申请或查看或继续编辑
    @IBAction func apply(_ sender: Any) {
        
        applyButton.isEnabled = false
        
        if let apl = apply {
            let editVC = UIStoryboard(name: "Edit", bundle: Bundle.main).instantiateViewController(withIdentifier: "edit") as! EditVC
            editVC.policyId = id
            editVC.policy = policy
            editVC.applyId = apl.id
            //editVC.apply = apl(进入后重新获取)
            editVC.isRootEdit = true
            editVC.navigationItem.title = policy?.shortTitle
            navigationController?.show(editVC, sender: nil)
        }else{
            NetworkHandler.share().policy.addApply(withPolicyId: self.id){ (resultCode, message, apply) in
                DispatchQueue.main.async {
                    guard resultCode == .success else{
                        self.notif(withTitle: message, closure: nil)
                        return
                    }
                    
                    if let apl = apply{
                        
                        let editVC = UIStoryboard(name: "Edit", bundle: Bundle.main).instantiateViewController(withIdentifier: "edit") as! EditVC
                        editVC.policyId = self.id
                        editVC.policy = self.policy
                        editVC.applyId = apl.id
                        //editVC.apply = apl(进入后重新获取)
                        editVC.isRootEdit = true
                        editVC.navigationItem.title = self.policy?.shortTitle
                        self.navigationController?.show(editVC, sender: nil)
                    }
                }
            }
        }
    }
    
    //MARK: 分享
    @IBAction func share(_ sender: Any) {
        ganAlert.swip()
    }
}

//MARK:- tableview delegate
extension PolicyVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let pol = policy else {
            return 0
        }
        
        switch section {
        case 0:         //图片
            return 1
        case 1:         //长标题
            return 1
        case 2:         //短标题
            return 1
        case 3:         //扶持对象
            return pol.applicantList.count
        case 4:         //1正文内容
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
        case 0:
            return view_size.width * 9 / 16
        case 1:         //引言
            let text = policy?.summary ?? ""
            let size = CGSize(width: view_size.width, height: view_size.width)
            let rect = NSString(string: text).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont(name: UIFont.mainName, size: .labelHeight)!], context: nil)
            
            return .edge8 + rect.height + .edge8
        case 2:         //标题
            return 44 * 2
        case 3:         //扶持对象
            let applicant = policy?.applicantList[row]
            
            let text = applicant?.detailText ?? ""
            let size = CGSize(width: view_size.width, height: view_size.width)
            let rect = NSString(string: text).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont(name: UIFont.mainName, size: .labelHeight)!], context: nil)
            
            
            return .edge8 + .labelHeight + .edge8 + rect.height + .edge8
        default:        //正文
            var text = ""
            if let pol = policy{
                if row < pol.documentList.count {
                    let document = pol.documentList[row]
                    text = document.title ?? ""
                }else{
                    let prize = pol.prizeList[row - pol.documentList.count]
                    text = prize.title ?? ""
                }
            }
            
            let size = CGSize(width: view_size.width - .edge8 * 2, height: view_size.width)
            let rect = NSString(string: text).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont(name: UIFont.mainName, size: .labelHeight)!], context: nil)
            return .edge8 + rect.height + .edge8
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        var identifier = ""
        
        var cell: UITableViewCell
        
        switch section {
        case 0:     //图片
            identifier = "image"
            let imageCell = tableView.dequeueReusableCell(withIdentifier: identifier) as! PolicyImageCell

            //图片
            if let picUrl = policy?.bigPicUrl {
                    do{
                        let imageData = try Data(contentsOf: picUrl)
                        let image = UIImage(data: imageData)
                        imageCell.headImageView.image = image
                    }catch{}
            }
            cell = imageCell
        case 1:     //引言
            identifier = "single"
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "single") as! PolicySingleLineCell
            singleCell.label.text = policy?.summary
            singleCell.label.font = .middle
            cell = singleCell
        case 2:     //标题
            identifier = "single"
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "single") as! PolicySingleLineCell
            singleCell.label.text = policy?.longTitle
            cell = singleCell
        case 3:     //扶持对象
            let muteCell = tableView.dequeueReusableCell(withIdentifier: "mute") as! PolicyMuteLineCell
            if let applicantList = policy?.applicantList{
                let applicant = applicantList[row]
                muteCell.titleLabel.text = "扶持对象  " + (applicant.name ?? "")
                muteCell.titleLabel.font = .middle
                muteCell.detailLabel.text = applicant.detailText
                muteCell.detailLabel.font = .small
            }
            cell = muteCell
        case 4:     //正文内容
            let contentCell = tableView.dequeueReusableCell(withIdentifier: "single") as! PolicySingleLineCell
            if let pol = policy{
                if row < pol.documentList.count {
                    let document = pol.documentList[row]
                    contentCell.label.text = document.title
                    if let type = document.type{
                        switch type{
                        case .chapter:
                            contentCell.label.font = .big
                            contentCell.label.textColor = .black
                        case .item:
                            contentCell.label.font = .middle
                            contentCell.label.textColor = .gray
                        case .paragraph:
                            contentCell.label.font = .middle
                            contentCell.label.textColor = .lightGray
                        }
                    }
                    if let contentType = document.contentType{
                        contentCell.label.font = .middle
                        switch contentType{
                        case .fold:
                            contentCell.label.textColor = .green
                        case .requirement:
                            contentCell.label.textColor = .red
                        case .text:
                            contentCell.label.textColor = .gray
                        }
                    }
                }else{
                    let prize = pol.prizeList[row - pol.documentList.count]
                    contentCell.label.text = prize.title
                }
            }
            cell = contentCell
        default:
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        return cell
    }
}
