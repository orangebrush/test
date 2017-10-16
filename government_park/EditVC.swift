//
//  EditVC.swift
//  government_park
//
//  Created by YiGan on 19/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
import gov_sdk
class EditVC: UIViewController {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var requireLabel: UILabel!
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var isRootEdit = true
    
    var policyId = 0
    var policy: Policy?         //政策详情
    
    var applyId = 0
    var apply: Apply?           //申请目录内容
    var item: Item?             //组或组件内容
    
    var componentId: Int?       //组件id
    var groupId: Int?           //组id
    var instanceId: Int?        //条目id
    
    //MARK:- init-------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        config()
        createContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if isRootEdit{
            topView.isHidden = false
            tableView.frame = CGRect(x: 0, y: 144, width: view_size.width, height: view_size.height - 116)
            
            //如果apply的编辑数据为空则通过applyId重新拉取
            NetworkHandler.share().status.getApply(withApplyId: applyId, closure: { (resultCode, message, apply) in
                DispatchQueue.main.async {
                    guard resultCode == .success else{
                        self.notif(withTitle: message, duration: 3, closure: nil)
                        return
                    }
                    self.apply = apply
                    
                    //设置topView字段
                    self.requireLabel.text = apply?.policyShortTitle
                    self.optionLabel.text = apply?.dateHint
                    self.infoLabel.text = apply?.statusHint
                    
                    //刷新
                    self.tableView.reloadData()
                }
            })
            
            //如果policy为空则通过policyId重新拉取
            if policy == nil{
                NetworkHandler.share().policy.getPolicy(withPolicyId: policyId, closure: { (resultCode, message, policy) in
                    DispatchQueue.main.async {
                        guard resultCode == .success else{
                            self.notif(withTitle: message, duration: 3, closure: nil)
                            return
                        }
                        self.policy = policy
                    }
                })
            }
        }else{
            topView.isHidden = true
            tableView.frame = CGRect(x: 0, y: 0, width: view_size.width, height: view_size.height)
            
            //清空右侧按钮
            navigationItem.rightBarButtonItems = []
            
            
            //刷新获取组结构
            let itemsParams = ItemsParams()
            itemsParams.applyId = applyId
            itemsParams.componentId = componentId!
            itemsParams.groupId = groupId
            itemsParams.instanceId = instanceId
            itemsParams.isInstance = instanceId == nil ? false : instanceId != 0      //判断是否为条目
            NetworkHandler.share().editor.getItems(withParams: itemsParams, closure: { (resultCode, message, item) in
                DispatchQueue.main.async {
                    guard resultCode == .success else{
                        self.notif(withTitle: message, duration: 3, closure: nil)
                        return
                    }
                    if let itm = item{
                        self.item = itm
                        self.componentId = itm.isRoot ? itm.id : itm.componentId
                        self.instanceId = itm.instanceId
                        if itm.isGroup{
                            self.groupId = itm.id
                        }
                    }
                    self.tableView.reloadData()
                }
            })
        }
        
        
    }
    
    private func config(){
        
        topView.layer.cornerRadius = .cornerRadius
    }
    
    private func createContents() {
        
    }
    
    //MARK:- 提交申请
    @IBAction func apply(_ sender: Any) {
        
    }
    
    //MARK:- 查看政策
    @IBAction func checkPolicy(_ sender: Any) {        
        if let policyCheckVC = storyboard?.instantiateViewController(withIdentifier: "policycheck") as? PolicyCheckVC{
            policyCheckVC.policy = policy
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
            guard let apl = apply else {
                return
            }
            
            NetworkHandler.share().rootEditor.cancelApply(withApplyId: apl.id, closure: { (resultCode, message, data) in
                DispatchQueue.main.async {
                    guard resultCode == .success else{
                        self.notif(withTitle: message, duration: 2, closure: nil)
                        return
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            })
            
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
        if isRootEdit{
            if let catalogList = apply?.catalogList{
                return catalogList.count
            }
            return 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isRootEdit{
            if let catalogList = apply?.catalogList{
                let catalog = catalogList[section]
                let itemList = catalog.baseItemList
                return itemList.count
            }
            return 0
        }
        
        if let baseItemList = item?.baseItemList{
            return baseItemList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return isRootEdit ? .labelHeight * 2 + .edge8 * 3 : 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerFrame = CGRect(x: 0, y: 0, width: view_size.width, height: .labelHeight * 2 + 8 * 3)
        let header = UIView(frame: headerFrame)
        header.tag = section
        
        if isRootEdit {
            let catalogList = apply?.catalogList
            let catalog = catalogList?[section]

            let title = catalog?.title
            
            let titleFrame = CGRect(x: .edge16, y: .edge8, width: headerFrame.width - .edge16 * 2, height: .labelHeight)
            let titleLabel = UILabel(frame: titleFrame)
            titleLabel.text = title
            titleLabel.font = .middle
            header.addSubview(titleLabel)
            
            let subTitleFrame = CGRect(x: .edge16, y: .edge8 * 2 + .labelHeight, width: headerFrame.width - .edge16, height: .labelHeight)
            let subTitleLabel = UILabel(frame: subTitleFrame)
            subTitleLabel.text = "---"
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
        if isRootEdit{
            return ItemType.GroupType.normal.height()
        }
        
        if let baseItemList = item?.baseItemList{
            let baseItem = baseItemList[indexPath.row]
            if baseItem.isGroup{
                return baseItem.groupType?.height() ?? .cellHeight
            }
            return baseItem.fieldType?.height() ?? .cellHeight
        }
        return .cellHeight
    }
    
    //MARK: 点击组(按钮事件)回调
    func clickGroup(withInstanceId instanceId: Int?, withComponentId componentId: Int, withGroupId groupId: Int?){
        
        let groupEditor = UIStoryboard(name: "Edit", bundle: Bundle.main).instantiateViewController(withIdentifier: "edit") as! EditVC
        groupEditor.isRootEdit = false
        //获取组结构
        let itemsParams = ItemsParams()
        itemsParams.applyId = applyId
        itemsParams.componentId = componentId
        itemsParams.groupId = groupId
        itemsParams.instanceId = instanceId
        itemsParams.isInstance = instanceId == nil ? false : instanceId != 0      //判断是否为条目
        NetworkHandler.share().editor.getItems(withParams: itemsParams, closure: { (resultCode, message, item) in
            DispatchQueue.main.async {
                guard resultCode == .success else{
                    self.notif(withTitle: message, duration: 3, closure: nil)
                    return
                }
                if let itm = item{
                    //groupEditor.item = itm
                    groupEditor.componentId = itm.isRoot ? itm.id : itm.componentId
                    groupEditor.instanceId = itm.instanceId
                    groupEditor.applyId = self.applyId
                    groupEditor.policyId = self.policyId
                    if itm.isGroup{
                        groupEditor.groupId = itm.id
                    }
                    self.navigationController?.show(groupEditor, sender: nil)
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        var cell: UITableViewCell
        
        //获取具体数据（组）（字段）
        var base: BaseItem
        if isRootEdit{
            let catalog = (apply?.catalogList)?[section]
            base = ((catalog?.baseItemList)?[row])!
            
            //如果为rootItem则必然为group
            let type = base.groupType!
            
            //创建group cell (组件为普通组，无需判断)
            let groupCell = tableView.dequeueReusableCell(withIdentifier: type.identifier()) as! Group0Cell
            groupCell.firstLabel.text = base.title
            if groupCell.secondLabel != nil{
                groupCell.secondLabel.text = base.hint
            }
            groupCell.closure = {
                instanceId in
                self.clickGroup(withInstanceId: instanceId == 0 ? self.instanceId : instanceId, withComponentId: self.apply!.catalogList[section].baseItemList[row].id, withGroupId: nil)
            }
            
            cell = groupCell

        }else{
            let baseItem = ((item?.baseItemList)?[row])!
            base = (baseItem as? BaseItem)!

            if base.isGroup{
                let groupType = base.groupType
                
                //创建group cell
                switch groupType!{
                case .normal:
                    let groupCell = tableView.dequeueReusableCell(withIdentifier: groupType!.identifier()) as! GroupCell
                    groupCell.firstLabel.text = base.title
                    if groupCell.secondLabel != nil{
                        groupCell.secondLabel.text = base.hint
                    }
                    groupCell.closure = {
                        instanceId in
                        self.clickGroup(withInstanceId: self.instanceId, withComponentId: self.componentId!, withGroupId: base.id)
                    }
                    cell = groupCell
                case .multi:
                    let groupCell = tableView.dequeueReusableCell(withIdentifier: groupType!.identifier()) as! GroupCell
                    groupCell.firstLabel.text = base.title
                    groupCell.secondLabel.text = base.hint
                    groupCell.closure = {
                        instanceId in
                        self.clickGroup(withInstanceId: instanceId == 0 ? self.instanceId : instanceId, withComponentId: self.componentId!, withGroupId: base.id)
                    }
                    cell = groupCell
                case .image:
                    let groupCell = tableView.dequeueReusableCell(withIdentifier: groupType!.identifier()) as! GroupCell
                    groupCell.firstLabel.text = base.title
                    groupCell.secondLabel.text = "限\(base.maxLength)张"
                    groupCell.closure = {
                        instanceId in
                        self.clickGroup(withInstanceId: self.instanceId, withComponentId: self.componentId!, withGroupId: base.id)
                    }
                    cell = groupCell
                case .time:
                    let groupCell = tableView.dequeueReusableCell(withIdentifier: groupType!.identifier()) as! GroupCell
                    groupCell.firstLabel.text = base.title
                    groupCell.secondLabel.text = base.hint
                    let valueList = base.valueList
                    for value in valueList{
                        groupCell.firstButton.setTitle(value.title, for: .normal)
                    }
                    groupCell.closure = {
                        instanceId in
                        self.clickGroup(withInstanceId: instanceId, withComponentId: self.componentId!, withGroupId: base.id)
                    }
                    cell = groupCell
                default:
                    let groupCell = tableView.dequeueReusableCell(withIdentifier: groupType!.identifier()) as! GroupCell
                    groupCell.firstLabel.text = base.title
                    groupCell.secondLabel.text = base.hint
                    groupCell.closure = {
                        instanceId in
                        self.clickGroup(withInstanceId: instanceId == 0 ? self.instanceId : instanceId, withComponentId: self.componentId!, withGroupId: base.id)
                    }
                    cell = groupCell
                }
            }else{
                let fieldType = base.fieldType
                
                //创建 field cell
                let assemblyCell = tableView.dequeueReusableCell(withIdentifier: fieldType!.identifier()) as! FieldCell
                assemblyCell.firstLabel.text = base.title
                assemblyCell.secondLabel.text = base.hint
                cell = assemblyCell
            }
        }
        return cell
    }
    
    //MARK: 点击选择，仅判断字段实例
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: true)
        
        if isRootEdit{
            
        }else{
            let baseItem = (item?.baseItemList)?[row]
            let base = baseItem as! BaseItem
            
            let fieldType = base.fieldType
            
            /*
             case .enclosure:
             return "field3"
             case .single:
             return "field4"
             case .multi:
             return "field6"
             case .time:
             return "field7"
             default:
             return "field5"
             */
            switch fieldType! {
            case .short:            //短文本
                let field0Editor = UIStoryboard(name: "Editor", bundle: Bundle.main).instantiateViewController(withIdentifier: fieldType!.identifier()) as! Field0Editor
                field0Editor.applyId = applyId
                field0Editor.componentId = componentId!
                field0Editor.instanceId = instanceId
                field0Editor.fieldId = base.id
                navigationController?.show(field0Editor, sender: nil)
            case .long:             //长文本
                let field1Editor = UIStoryboard(name: "Editor", bundle: Bundle.main).instantiateViewController(withIdentifier: fieldType!.identifier()) as! Field1Editor
                field1Editor.applyId = applyId
                field1Editor.componentId = componentId!
                field1Editor.instanceId = instanceId
                field1Editor.fieldId = base.id
                navigationController?.show(field1Editor, sender: nil)
            case .image:            //图片
                let field2Editor = UIStoryboard(name: "Editor", bundle: Bundle.main).instantiateViewController(withIdentifier: fieldType!.identifier()) as! Field2Editor
                field2Editor.applyId = applyId
                field2Editor.componentId = componentId!
                field2Editor.instanceId = instanceId
                field2Editor.fieldId = base.id
                navigationController?.show(field2Editor, sender: nil)
            case .enclosure:        //附件
                let field3Editor = UIStoryboard(name: "Editor", bundle: Bundle.main).instantiateViewController(withIdentifier: fieldType!.identifier()) as! Field3Editor
                field3Editor.applyId = applyId
                field3Editor.componentId = componentId!
                field3Editor.instanceId = instanceId
                field3Editor.fieldId = base.id
                navigationController?.show(field3Editor, sender: nil)
            case .single:           //单选
                let field4Editor = UIStoryboard(name: "Editor", bundle: Bundle.main).instantiateViewController(withIdentifier: fieldType!.identifier()) as! Field4Editor
                field4Editor.applyId = applyId
                field4Editor.componentId = componentId!
                field4Editor.instanceId = instanceId
                field4Editor.fieldId = base.id
                navigationController?.show(field4Editor, sender: nil)
            case .multi:            //多选
                let field6Editor = UIStoryboard(name: "Editor", bundle: Bundle.main).instantiateViewController(withIdentifier: fieldType!.identifier()) as! Field6Editor
                field6Editor.applyId = applyId
                field6Editor.componentId = componentId!
                field6Editor.instanceId = instanceId
                field6Editor.fieldId = base.id
                navigationController?.show(field6Editor, sender: nil)
            case .time:            //时间
                let field7Editor = UIStoryboard(name: "Editor", bundle: Bundle.main).instantiateViewController(withIdentifier: fieldType!.identifier()) as! Field7Editor
                field7Editor.applyId = applyId
                field7Editor.componentId = componentId!
                field7Editor.instanceId = instanceId
                field7Editor.fieldId = base.id
                navigationController?.show(field7Editor, sender: nil)
            default:                //联动
                let field5Editor = UIStoryboard(name: "Editor", bundle: Bundle.main).instantiateViewController(withIdentifier: fieldType!.identifier()) as! Field5Editor
                field5Editor.applyId = applyId
                field5Editor.componentId = componentId!
                field5Editor.instanceId = instanceId
                field5Editor.fieldId = base.id
                navigationController?.show(field5Editor, sender: nil)
            }
        }
    }
}
