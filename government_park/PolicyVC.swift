//
//  Policy.swift
//  government_park
//
//  Created by YiGan on 19/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
import government_sdk
class PolicyVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var collectionButton: UIButton!
    
    private var image: UIImage?{
        didSet{
            
        }
    }
    
    //政策
    fileprivate var detailPolicyModel: DetailPolicyModel?{
        didSet{
            guard let model = detailPolicyModel else {
                return
            }            
            
            //是否可收藏
            Handler.getIsCompanyBookmarkApply(withPolicyId: model.id!){
                resultCode, message, bookmarkPolicyVirginModel in
                
                DispatchQueue.main.async {
                    guard resultCode == .success else{
                        self.notif(withTitle: message, duration: 1, closure: nil)
                        return
                    }
                    self.collectionButton.isEnabled = true
                    self.collectionButton.isHidden = false
                    self.collectionButton.isSelected = bookmarkPolicyVirginModel != nil
                }
            }
            
            tableView.reloadData()
        }
    }
    
    //申请
    fileprivate var applyInstance: ApplyInstance?{
        didSet{
            guard let instance = applyInstance else {
                return
            }
            
            applyButton.isEnabled = true
            
            //判断是否已申请
            applyButton.setTitle(instance.statusHint!, for: .normal)
        }
    }
    
    //政策id
    var id = 0
    
    //申请id
    var applyId = 0
    
    
    //MARK:- init--------------------------------------------------
    override func viewDidLoad() {
        
        config()
        createContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        collectionButton.isHidden = true
        applyButton.setTitle("申请", for: .normal)
        
        navigationController?.isNavigationBarHidden = false
        
        //获取政策详情
        Handler.getDetailPolicy(withPolicyId: id){
            resultCode, message, detailPolicyModel in
            
            DispatchQueue.main.async {
                guard resultCode == .success else{
                    self.notif(withTitle: message, duration: 1, closure: nil)
                    return
                }
                
                self.detailPolicyModel = detailPolicyModel
            }
            
            //获取申请
            Handler.getUserApply{
                resultCode, message, applyListModelList in
                
                guard resultCode == .success else{
                    DispatchQueue.main.async {
                        self.login()
                    }
                    return
                }
                
                guard let list = applyListModelList else{
                    //新建申请
                    Handler.getApplyContents(withPolicyId: self.id, self.getApplyInstance)
                    return
                }
                
                //判断是否已编辑过申请
                let resultList = list.filter({$0.policyId == self.applyId})
                if resultList.isEmpty{
                    //新建申请
                    Handler.getApplyContents(withPolicyId: self.id, self.getApplyInstance)
                }else{
                    //继续申请
                    self.applyId = resultList[0].id
                    Handler.getApplyContents(withApplyId: self.applyId, self.getApplyInstance)
                }
            }
        }
    }
    
    //MARK:- 获取到申请目录后回调
    private func getApplyInstance(resultCode: ResultCode, message: String, applyInstance: ApplyInstance?){
        DispatchQueue.main.async {
            guard resultCode == .success else {
                self.notif(withTitle: message, duration: 1, closure: nil)
                return
            }
            guard let instance = applyInstance else{
                return
            }
            
            self.applyInstance = instance
        }
    }
    
    private func config(){
        
        automaticallyAdjustsScrollViewInsets = false
    }
    
    private func createContents(){
        
    }
    
    //MARK: 收藏
    @IBAction func collection(_ sender: UIButton) {
        collectionButton.isSelected = !collectionButton.isSelected
    }
    
    //MARK:- 申请或查看或继续编辑
    @IBAction func apply(_ sender: Any) {
        
        let editVC = UIStoryboard(name: "Edit", bundle: Bundle.main).instantiateViewController(withIdentifier: "edit") as! EditVC
        editVC.detailPolicyModel = detailPolicyModel
        editVC.isRootEdit = true
        editVC.policyId = id
        editVC.applyId = applyId
        editVC.applyInstance = applyInstance
        //editVC.catalogsList = applyInstance?.catalogs
        navigationController?.show(editVC, sender: nil)
    }
    
    //MARK: 分享
    @IBAction func share(_ sender: Any) {
        
    }
}

//MARK:- tableview delegate
extension PolicyVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = detailPolicyModel else {
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
            return model.applyTo?.count ?? 0
        case 4:         //1正文内容
            if model.document == nil || model.prizes == nil{
                return 0
            }
            return (model.document?.count ?? 0) + (model.prizes?.count ?? 0)
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
            let text = detailPolicyModel?.summary ?? ""
            let size = CGSize(width: view_size.width, height: view_size.width)
            let rect = NSString(string: text).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont(name: UIFont.mainName, size: .labelHeight)!], context: nil)
            
            return .edge8 + rect.height + .edge8
        case 2:         //标题
            return 44 * 2
        case 3:         //扶持对象
            let applyto = detailPolicyModel?.applyTo?[row]
            
            let text = applyto?.description ?? ""
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
        case 0:     //图片
            identifier = "image"
            let imageCell = tableView.dequeueReusableCell(withIdentifier: identifier) as! PolicyImageCell

            //图片
            if let picString = detailPolicyModel?.bigPic {
                if let url = URL(string: picString){
                    do{
                        let imageData = try Data(contentsOf: url)
                        let image = UIImage(data: imageData)
                        imageCell.headImageView.image = image
                    }catch{}
                }
            }
            cell = imageCell
        case 1:     //引言
            identifier = "single"
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "single") as! PolicySingleLineCell
            singleCell.label.text = detailPolicyModel?.summary
            singleCell.label.font = .middle
            cell = singleCell
        case 2:     //标题
            identifier = "single"
            let singleCell = tableView.dequeueReusableCell(withIdentifier: "single") as! PolicySingleLineCell
            singleCell.label.text = detailPolicyModel?.longTitle
            cell = singleCell
        case 3:     //扶持对象
            let muteCell = tableView.dequeueReusableCell(withIdentifier: "mute") as! PolicyMuteLineCell
            if let applyto = detailPolicyModel?.applyTo?[row]{
                muteCell.titleLabel.text = "扶持对象  " + applyto.target
                muteCell.detailLabel.text = applyto.description
            }
            cell = muteCell
        case 4:     //正文内容
            let muteCell = tableView.dequeueReusableCell(withIdentifier: "mute") as! PolicyMuteLineCell
            if let model = detailPolicyModel{
                if row < model.document!.count {
                    if let document = model.document?[row]{
                        muteCell.titleLabel.text = document.title! + document.contentType!
                    }
                }else{
                    if let prize = model.prizes?[row - model.document!.count]{
                        muteCell.titleLabel.text = prize.title!
                    }
                }
            }
            cell = muteCell
        default:
            cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        }
        return cell
    }
}
