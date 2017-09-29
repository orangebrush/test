//
//  EditVC.swift
//  government_park
//
//  Created by YiGan on 19/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
import government_sdk
class EditVC: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var requireLabel: UILabel!
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var isRootEdit = true
    var policyId = 0
    var applyId = 0

    var detailPolicyModel: DetailPolicyModel?       //政策详情
    
    var applyInstance: ApplyInstance? {             //申请目录
        didSet{
            tableView.reloadData()
        }
    }
    
    //目录
    var catalogsList: [ApplyCatalogs]?{
        didSet{
            tableView.reloadData()
            catalogsList?.first?.components
        }
    }
    
    //组件or组
    var modelList: [BaseExampleModel]?{
        didSet{
            
        }
    }
    
    //MARK:- init-------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if isRootEdit{
            topView.isHidden = false
            tableView.frame = CGRect(x: 0, y: 144, width: view_size.width, height: view_size.height - 116)
        }else{
            topView.isHidden = true
            tableView.frame = CGRect(x: 0, y: 0, width: view_size.width, height: view_size.height)
            
            //清空右侧按钮
            navigationItem.rightBarButtonItems = []
        }
        
        topView.layer.cornerRadius = .cornerRadius
        
    }
    
    private func config(){
        
    }
    
    private func createContents() {
        
    }
    
    //MARK:- 提交申请
    @IBAction func apply(_ sender: Any) {
        
    }
    
    //MARK:- 查看政策
    @IBAction func checkPolicy(_ sender: Any) {        
        if let policyCheckVC = storyboard?.instantiateViewController(withIdentifier: "policycheck") as? PolicyCheckVC{
            policyCheckVC.detailPolicyModel = detailPolicyModel
            navigationController?.show(policyCheckVC, sender: nil)
        }
    }
    
    //MARK:- 其他操作
    @IBAction func more(_ sender: Any) {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "关闭", destructiveButtonTitle: "取消这个申请", otherButtonTitles: "登陆网页版")
        actionSheet.show(in: view)
        actionSheet.show(from: CGRect(x:0, y:12, width: 123, height: 323), in: view, animated: true)
    }
    
    //MARK: 点击header回调（用于展开与收起一级目录）
    @objc fileprivate func clickHeader(tap: UITapGestureRecognizer){
        guard let header = tap.view else{
            return
        }
        
        let tag = header.tag
    }
}

//MARK:- action sheet delegate
extension EditVC: UIActionSheetDelegate{
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            //取消这个申请
            guard let instance = applyInstance else {
                return
            }
            Handler.cancelApply(withApplyId: instance.id){
                resultCode, message in
                self.navigationController?.popViewController(animated: true)
            }
            
        case 1:
            print("关闭")
        case 2:
            print("登陆网页版")
        default:
            print("other")
        }
    }
}

//MARK:- tableview delegate
extension EditVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isRootEdit ? .labelHeight * 2 + .edge8 * 3 : 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFrame = CGRect(x: 0, y: 0, width: view_size.width, height: .labelHeight * 2 + 8 * 3)
        let header = UIView(frame: headerFrame)
        header.tag = section
        
        if isRootEdit {
            let titleFrame = CGRect(x: .edge16, y: .edge8, width: headerFrame.width - .edge16 * 2, height: .labelHeight)
            let titleLabel = UILabel(frame: titleFrame)
            titleLabel.text = "title"
            titleLabel.font = .middle
            header.addSubview(titleLabel)
            
            let subTitleFrame = CGRect(x: .edge16, y: .edge8 * 2 + .labelHeight, width: headerFrame.width - .edge16, height: .labelHeight)
            let subTitleLabel = UILabel(frame: subTitleFrame)
            subTitleLabel.text = "subTitle"
            subTitleLabel.font = .small
            header.addSubview(subTitleLabel)
        
            //添加点击事件(在第一级页面有张开收起功能)
            let tap = UITapGestureRecognizer(target: self, action: #selector(clickHeader(tap:)))
            tap.numberOfTouchesRequired = 1
            tap.numberOfTapsRequired = 1
            header.addGestureRecognizer(tap)
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FieldType.image.height()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        var cell: UITableViewCell
        
        let type = 0
        if type == 0{
            let assemblyCell = tableView.dequeueReusableCell(withIdentifier: "field2") as! Field2Cell
            cell = assemblyCell
        }else{
            let groupCell = tableView.dequeueReusableCell(withIdentifier: "group0") as! Group0Cell
            groupCell.closure = {
                _ in
                
                let groupEditor = UIStoryboard(name: "Edit", bundle: Bundle.main) as! EditVC
                groupEditor.isRootEdit = false
                self.navigationController?.show(groupEditor, sender: nil)

            }
            cell = groupCell
        }
        return cell
    }
    
    //MARK: 点击选择，仅判断字段实例
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        let field2Editor = UIStoryboard(name: "Editor", bundle: Bundle.main).instantiateViewController(withIdentifier: "field2") as! Field2Editor
        navigationController?.show(field2Editor, sender: nil)
    }
}
