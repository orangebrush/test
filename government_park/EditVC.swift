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
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        createContents()
    }
    
    private func config(){
        
        infoLabel.font = .small
        infoLabel.textColor = .gray
        applyButton.isHidden = true
        
        topView.layer.cornerRadius = .cornerRadius
    }
    
    fileprivate func createContents() {
        if isRootEdit{
            topView.isHidden = false
            
            //tableView.frame = CGRect(x: 0, y: 144, width: view_size.width, height: view_size.height - 116)
            tableViewTopConstraint.constant = .edge8
            
            //如果apply的编辑数据为空则通过applyId重新拉取
            NetworkHandler.share().status.getApply(withApplyId: applyId, closure: { (resultCode, message, apply) in
                DispatchQueue.main.async {
                    guard resultCode == .success else{
                        self.notif(withTitle: message, closure: nil)
                        return
                    }
                    self.apply = apply
                    
                    //设置topView字段
                    self.requireLabel.text = apply?.statusHint
                    self.optionLabel.text = apply?.dateHint
                    if let apl = apply{
                        if apl.finished == 100{
                            self.applyButton.layer.cornerRadius = .cornerRadius
                            self.applyButton.isHidden = false
                            self.infoLabel.text = "必填项目已完成，请在核实资料无误、全面后，正式将申请提交给政府。"
                        }else{
                            self.applyButton.isHidden = true
                            self.infoLabel.text = ""
                        }
                    }
                    
                    //刷新
                    self.tableView.reloadData()
                }
            })
            
            //如果policy为空则通过policyId重新拉取
            if policy == nil{
                NetworkHandler.share().policy.getPolicy(withPolicyId: policyId, closure: { (resultCode, message, policy) in
                    DispatchQueue.main.async {
                        guard resultCode == .success else{
                            self.notif(withTitle: message, closure: nil)
                            return
                        }
                        self.policy = policy
                    }
                })
            }
        }else{
            topView.isHidden = true
            //tableView.frame = CGRect(x: 0, y: 0, width: view_size.width, height: view_size.height)
            tableViewTopConstraint.constant = -116 - .edge8
            
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
                        self.notif(withTitle: message, closure: nil)
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
    
    //MARK:- 提交申请
    @IBAction func apply(_ sender: Any) {

        NetworkHandler.share().rootEditor.submitApply(withApplyId: applyId) { (resultCode, message, data) in
            DispatchQueue.main.async {
                self.notif(withTitle: message, closure: nil)
                guard resultCode == .success else{
                    return
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
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
            let scanVC = UIStoryboard(name: "Contents", bundle: Bundle.main).instantiateViewController(withIdentifier: "scan") as! ScanVC
            navigationController?.show(scanVC, sender: nil)
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
            subTitleLabel.text = catalog?.detailTitle //"---"
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
                let base = (baseItem as? BaseItem)!
                let groupType = base.groupType
                
                //创建group cell
                switch groupType!{
                case .multi:
                    //添加条目按钮
                    return (baseItem.groupType?.height() ?? .cellHeight) + CGFloat(base.valueList.count) * (.buttonHeight + .edge8)
//                case .image:
//                    let maxValueCount = base.maxValueCount
//                    let curCount = base.valueList.count
//                    let originHeight = baseItem.groupType?.height() ?? .cellHeight
//                    let addHeight = CGFloat(ceil(Double(curCount) / Double(maxValueCount / 2)))
//                    return originHeight + addHeight
                default:
                    return baseItem.groupType?.height() ?? .cellHeight
                }
            }
            
            if let text = baseItem.hint{    //子标签内容
                let size = CGSize(width: view_size.width, height: view_size.width)
                let rect = NSString(string: text).boundingRect(with: size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont(name: UIFont.mainName, size: .labelHeight)!], context: nil)
                return .edge8 + .labelHeight + .edge8 + rect.height + .edge8
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
                    self.notif(withTitle: message, closure: nil)
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
                    groupEditor.navigationItem.title = itm.title
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
                case .normal:       //done
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
                case .multi:        //done
                    let group2Cell = tableView.dequeueReusableCell(withIdentifier: groupType!.identifier()) as! Group2Cell
                    group2Cell.firstLabel.text = base.title
                    group2Cell.secondLabel.text = base.hint
                    group2Cell.firstButton.tag = 0              //add按钮
                    group2Cell.firstButton.layer.cornerRadius = .cornerRadius
                    //添加条目按钮
                    if !group2Cell.addedInstanceButtons{
                        group2Cell.addedInstanceButtons = true
                        let x = CGFloat.edge16 + .edge8
                        var y = group2Cell.secondLabel.frame.origin.y
                        let width = group2Cell.frame.width - x - .edge8
                        let height = CGFloat.buttonHeight
                        for value in base.valueList{
                            y += (.buttonHeight + .edge8)
                            let subviews = group2Cell.contentView.subviews
                            let oldTagList = subviews.map({$0.tag})
                            if oldTagList.contains(value.id){
                                if let oldView = subviews.filter({$0.tag == value.id}).first{
                                    if let oldButton = oldView as? UIButton{
                                        oldButton.setTitle(value.title, for: .normal)
                                    }
                                }
                            }else{
                                let buttonFrame = CGRect(x: x, y: y, width: width, height: height)
                                let button = UIButton(type: .custom)
                                button.frame = buttonFrame
                                button.layer.cornerRadius = .cornerRadius
                                button.backgroundColor = .gray
                                button.setTitle(value.title, for: .normal)
                                button.tag = value.id
                                button.addTarget(group2Cell, action: #selector(group2Cell.click(_:)), for: .touchUpInside)
                                group2Cell.addSubview(button)
                            }
                        }
                    }
                    group2Cell.closure = {
                        instanceId in
                        if instanceId == 0{     //新建条目
                            guard let text = group2Cell.instanceTextfield.text else{
                                self.notif(withTitle: "条目名不能为空", closure: nil)
                                return
                            }
                            let addInstanceParams = AddInstanceParams()
                            addInstanceParams.applyId = self.applyId
                            addInstanceParams.componentId = self.componentId!
                            addInstanceParams.groupId = base.id
                            addInstanceParams.instanceId = self.instanceId
                            addInstanceParams.instanceTitle = text
                            NetworkHandler.share().editor.addInstance(withAddInstanceParams: addInstanceParams, closure: { (resultCode, message, newInstance) in
                                DispatchQueue.main.async {
                                    self.notif(withTitle: message, closure: nil)
                                    guard resultCode == .success else{
                                        return
                                    }
                                    group2Cell.addedInstanceButtons = false
                                    self.createContents()
                                }
                            })
                        }else{                  //获取条目内容
                            self.clickGroup(withInstanceId: instanceId == 0 ? self.instanceId : instanceId, withComponentId: self.componentId!, withGroupId: base.id)
                        }
                    }
                    cell = group2Cell
                case .image:
                    let group3Cell = tableView.dequeueReusableCell(withIdentifier: groupType!.identifier()) as! Group3Cell
                    group3Cell.firstLabel.text = base.title
                    let maxValueCount = base.maxValueCount
                    group3Cell.secondLabel.text = "限\(maxValueCount)张"
                    let curCount = base.valueList.count
                    
                    //创建图片列表
                    for (index, value) in base.valueList.enumerated(){
                        let subviews = group3Cell.imagesView.subviews
                        let oldTagList = subviews.map({$0.tag})
                        if oldTagList.contains(value.id){
                            if let oldView = subviews.filter({$0.tag == value.id}).first{
                                if let oldImageView = oldView as? UIImageView{
                                    if let imageStr = value.title{
                                        if let imageURL = URL(string: imageStr){
                                            DispatchQueue.global().async {
                                                let imageData = try! Data(contentsOf: imageURL)
                                                let image = UIImage(data: imageData)
                                                DispatchQueue.main.async {
                                                    oldImageView.image = image
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }else{
                            
                            let x = CGFloat.edge8 + CGFloat(index) * ((group3Cell.frame.width - .imageHeight - .edge8 * 2) / CGFloat(curCount))
                            let y = CGFloat.edge8// + CGFloat(index / Int(maxValueCount / 2)) * (.imageHeight + .edge8)
                            let width = CGFloat.imageHeight
                            let imageFrame = CGRect(x: x , y: y, width: width, height: width)
                            let imageView = UIImageView(frame: imageFrame)
                            imageView.tag = value.id
                            imageView.contentMode = .scaleToFill
                            if let imageStr = value.title{
                                if let imageURL = URL(string: imageStr){
                                    DispatchQueue.global().async {
                                        do{
                                            if let imageData = try? Data(contentsOf: imageURL){                                                
                                                let image = UIImage(data: imageData)
                                                DispatchQueue.main.async {
                                                    imageView.image = image
                                                }
                                            }
                                        }catch let error{
                                            print("load image error: \(error)")
                                        }
                                    }
                                }
                            }
                            //为单个图片添加点击事件
                            let tap = UITapGestureRecognizer(target: group3Cell, action: #selector(group3Cell.tap(_:)))
                            tap.numberOfTapsRequired = 1
                            tap.numberOfTouchesRequired = 1
                            imageView.isUserInteractionEnabled = true
                            imageView.addGestureRecognizer(tap)
                            group3Cell.imagesView?.addSubview(imageView)
                        }
                    }
                    group3Cell.closure = {
                        imageViewTag in
                        
                        let group3Editor = UIStoryboard(name: "Editor", bundle: Bundle.main).instantiateViewController(withIdentifier: "group3") as! Group3Editor
                        group3Editor.maxCount = maxValueCount
                        group3Editor.instanceId = base.instanceId
                        group3Editor.applyId = self.applyId
                        group3Editor.componentId = self.componentId!
                        group3Editor.groupId = base.id
                        group3Editor.valueList = base.valueList
                        group3Editor.navigationItem.title = base.title
                        self.navigationController?.show(group3Editor, sender: nil)
                        
                    }
                    cell = group3Cell
                case .time:     //done
                    let groupCell = tableView.dequeueReusableCell(withIdentifier: groupType!.identifier()) as! GroupCell
                    groupCell.firstLabel.text = base.title
                    if groupCell.secondLabel != nil{
                        groupCell.secondLabel.text = base.hint ?? ""
                    }
                    let valueList = base.valueList
                    groupCell.firstButton.isHidden = true
                    groupCell.secondButton.isHidden = true
                    for (index, value) in valueList.enumerated(){
                        if index == 0{
                            groupCell.firstButton.isHidden = false
                            groupCell.firstButton.setTitle(value.title, for: .normal)
                            groupCell.firstButton.tag = value.id
                        }else{
                            groupCell.secondButton.isHidden = false
                            groupCell.secondButton.setTitle(value.title, for: .normal)
                            groupCell.secondButton.tag = value.id
                        }
                    }
                    groupCell.closure = {
                        instanceId in
                        self.clickGroup(withInstanceId: instanceId, withComponentId: self.componentId!, withGroupId: base.id)
                    }
                    cell = groupCell
                default:    //timepoint done
                    let groupCell = tableView.dequeueReusableCell(withIdentifier: groupType!.identifier()) as! GroupCell
                    groupCell.firstLabel.text = base.title
                    
                    for (index, value) in base.valueList.enumerated(){
                        if index == 0{
                            groupCell.firstButton.tag = value.id
                            groupCell.firstButton.setTitle(value.title, for: .normal)
                        }else{
                            groupCell.secondButton.tag = value.id
                            groupCell.secondButton.setTitle(value.title, for: .normal)
                        }
                    }

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
                assemblyCell.secondLabel.sizeToFit()
                cell = assemblyCell
                cell.sizeToFit()
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
            
            guard !base.isGroup else{
                return
            }
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
            case .short:            //短文本done
                let field0Editor = UIStoryboard(name: "Editor", bundle: Bundle.main).instantiateViewController(withIdentifier: fieldType!.identifier()) as! Field0Editor
                field0Editor.applyId = applyId
                field0Editor.componentId = componentId!
                field0Editor.instanceId = instanceId
                field0Editor.fieldId = base.id
                field0Editor.navigationItem.title = base.title
                field0Editor.prefix = base.prefix
                field0Editor.suffix = base.suffix
                field0Editor.maxLength = base.maxLength
                field0Editor.maxValue = base.maxValue
                navigationController?.show(field0Editor, sender: nil)
            case .long:             //长文本done
                let field1Editor = UIStoryboard(name: "Editor", bundle: Bundle.main).instantiateViewController(withIdentifier: fieldType!.identifier()) as! Field1Editor
                field1Editor.applyId = applyId
                field1Editor.componentId = componentId!
                field1Editor.instanceId = instanceId
                field1Editor.fieldId = base.id
                field1Editor.navigationItem.title = base.title
                field1Editor.fieldTypeValue = base.fieldTypeValue
                field1Editor.text = base.hint
                field1Editor.maxLength = base.maxLength
                navigationController?.show(field1Editor, sender: nil)
            case .image:            //图片
                let field2Editor = UIStoryboard(name: "Editor", bundle: Bundle.main).instantiateViewController(withIdentifier: fieldType!.identifier()) as! Field2Editor
                field2Editor.applyId = applyId
                field2Editor.componentId = componentId!
                field2Editor.instanceId = instanceId
                field2Editor.fieldId = base.id
                field2Editor.navigationItem.title = base.title
                navigationController?.show(field2Editor, sender: nil)
            case .enclosure:        //附件
                let field3Editor = UIStoryboard(name: "Editor", bundle: Bundle.main).instantiateViewController(withIdentifier: fieldType!.identifier()) as! Field3Editor
                field3Editor.applyId = applyId
                field3Editor.componentId = componentId!
                field3Editor.instanceId = instanceId
                field3Editor.fieldId = base.id
                field3Editor.navigationItem.title = base.title
                navigationController?.show(field3Editor, sender: nil)
            case .single:           //单选done
                let field4Editor = UIStoryboard(name: "Editor", bundle: Bundle.main).instantiateViewController(withIdentifier: fieldType!.identifier()) as! Field4Editor
                field4Editor.applyId = applyId
                field4Editor.componentId = componentId!
                field4Editor.instanceId = instanceId
                field4Editor.fieldId = base.id
                field4Editor.fieldTypeValue = base.fieldTypeValue
                field4Editor.navigationItem.title = base.title
                navigationController?.show(field4Editor, sender: nil)
            case .multi:            //多选done
                let field6Editor = UIStoryboard(name: "Editor", bundle: Bundle.main).instantiateViewController(withIdentifier: fieldType!.identifier()) as! Field6Editor
                field6Editor.applyId = applyId
                field6Editor.componentId = componentId!
                field6Editor.instanceId = instanceId
                field6Editor.fieldId = base.id
                field6Editor.fieldTypeValue = base.fieldTypeValue
                if field6Editor.fieldTypeValue == 9390{
                    field6Editor.policyId = policyId
                }
                field6Editor.valueList = base.valueList
                field6Editor.navigationItem.title = base.title
                navigationController?.show(field6Editor, sender: nil)
            case .time:            //时间done
                let field7Editor = UIStoryboard(name: "Editor", bundle: Bundle.main).instantiateViewController(withIdentifier: fieldType!.identifier()) as! Field7Editor
                field7Editor.applyId = applyId
                field7Editor.componentId = componentId!
                field7Editor.instanceId = instanceId
                field7Editor.fieldId = base.id
                field7Editor.fieldTypeValue = base.fieldTypeValue
                field7Editor.navigationItem.title = base.title
                navigationController?.show(field7Editor, sender: nil)
            default:                //联动done
                let field5Editor = UIStoryboard(name: "Editor", bundle: Bundle.main).instantiateViewController(withIdentifier: fieldType!.identifier()) as! Field5Editor
                field5Editor.applyId = applyId
                field5Editor.componentId = componentId!
                field5Editor.instanceId = instanceId
                field5Editor.fieldId = base.id
                field5Editor.fieldTypeValue = base.fieldTypeValue
                field5Editor.navigationItem.title = base.title                
                navigationController?.show(field5Editor, sender: nil)
            }
        }
    }
}
