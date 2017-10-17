//
//  Status1VC.swift
//  government_park
//
//  Created by YiGan on 26/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//审核中 等待

import UIKit
import gov_sdk
class AuditingVC: UIViewController {
    
    @IBOutlet weak var label0: UILabel!
    @IBOutlet weak var label0HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var button0: UIButton!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label1HeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var button1: UIButton!
    
    private let networkHandler = NetworkHandler.share()
    private var apply: Apply?
    private var policyId: Int = 0
    
    var applyId = 0
    
    
    //MARK:- init-----------------------------------------------------
    override func viewDidLoad() {
        label0.isHidden = true
        button0.isHidden = true
        label1.isHidden = true
        button1.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        config()
    }
    
    private func config(){
        NetworkHandler.share().status.getApply(withApplyId: applyId) { (resultCode, message, apply) in
            DispatchQueue.main.async {
                guard resultCode == .success else{
                    self.notif(withTitle: message, closure: nil)
                    self.navigationController?.popViewController(animated: true)
                    return
                }
                self.apply = apply
                self.policyId = apply?.policyId ?? 0
                self.updateContents()
            }
        }
    }
    
    private func updateContents(){
        /*
         //状态列表
         fileprivate var applyStatusListList: [[ApplyStatus]] = [
         [.undetermined, .reservation],                                      //已进入线下办理环节
         [.unread, .untreated, .interested, .notConsider],                   //审核中
         [.initial, .editing, .waiting],                                     //填写在线申请材料
         [.reject, .approval, .refuse, .overdue, .underCarriage, .black, .interrupt]    //已完结
         ]
         
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
        guard let applyStatus = apply?.applyStatus else{
            return
        }
        guard let instanceStatus = apply?.instanceStatus else{
            return
        }
        
        guard instanceStatus == .normal else {
            //企业强制取消
            label0.text = "你已经主动取消了这个申请，但你填写过的资料依然被妥善保存。你可以随时再次开启这个申请，你填写过的资料都将自动复原。"
            button0.setTitle("重启申请", for: .normal)
            label1.text = "如果你暂时不会申请这个政策，你可以点击下面的按钮把它从你的个人中心里清除掉。别担心，你填写过的数据可以随时还原。"
            button1.setTitle("移除申请", for: .normal)
            
            label0.isHidden = false
            button0.isHidden = false
            label1.isHidden = false
            button1.isHidden = false
            return
        }

        switch applyStatus {
        case .unread, .untreated, .interested, .notConsider:        //审核中
            label0.text = "申请已于3天前提交，正在等待政府人员审核。如果发现提交的数据有误，你总是可以撤回申请，修改之后重新提交这份申请。但这样会造成申请的延后，因为这将导致你回到申请队列的末尾。"
            button0.setTitle("撤回申请", for: .normal)
            
            label0.isHidden = false
            button0.isHidden = false
            label1.isHidden = true
            button1.isHidden = true
        case .reject:           //驳回
            label0.text = "申请被驳回，请查看具体反馈，然后点击修改申请。进入修改功能后，你可以选择修改后再次提交这份申请，也可以选择取消这个申请。"
            button0.setTitle("修改申请", for: .normal)
            label0.isHidden = false
            button0.isHidden = false
            label1.isHidden = true
            button1.isHidden = true
        case .approval:         //决定拨款
            label0.text = "恭喜你成功获得了政府的拨款!如果这个政策支持多次申请，你可以点击下面的按钮再次申请这个政策。"
            button0.setTitle("再次申请", for: .normal)
            label0.isHidden = false
            button0.isHidden = false
            label1.isHidden = true
            button1.isHidden = true
        case .refuse:           //拒绝拨款
            label0.text = "失败乃成功之母，如果你的企业情况有变，我们随时欢迎你再次提交申请。"
            button0.setTitle("再战一次", for: .normal)
            label1.text = "如果你决定不再战，你可以点击下面按钮把它从你的列表里清除掉。别担心，你填写过的数据可以随时还原。"
            button1.setTitle("移除申请", for: .normal)
            label0.isHidden = false
            button0.isHidden = false
        case .interrupt:        //强制中断
            label0.isHidden = false
            button0.isHidden = false
            if let reason = apply?.reason{
                label0.text = "你的申请已经被强制中断，原因: " + reason
            }else{
                label0.isHidden = true
            }
            button0.setTitle("移除这个申请记录", for: .normal)
            label1.isHidden = true
            button1.isHidden = true
        default:
            break
        }
        
        label0.sizeToFit()
        label1.sizeToFit()
    }
    
    //按钮点击
    @IBAction func clickButton(_ sender: UIButton) {
        let tag = sender.tag
        
        guard let apl = apply else {
            return
        }

        guard let applyStatus = apl.applyStatus else{
            return
        }
        
        guard let instanceStatus = apl.instanceStatus else{
            //获取的为移除前的申请，直接返回根视图
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        
        guard instanceStatus == .normal else {
            //企业强制取消
            if tag == 0 {
                //重启申请
                showEditVCAfterRemove()
            }else{
                //移除申请
                popAfterRemoved()
            }
            return
        }
        
        switch applyStatus {
        case .unread, .untreated, .interested, .notConsider:        //审核中
            //撤回申请
            showEditVCAfterRecall()
        case .reject:           //驳回
            //修改申请
            showEditVC()
        case .approval:         //决定拨款
            //再次申请
            showEditVC()
        case .refuse:           //拒绝拨款
            if tag == 0{
                //再战一次
                showEditVC()
            }else{
                //移除申请
                popAfterRemoved()
            }
        case .interrupt:        //强制中断
            //移除这个申请记录
            popAfterRemoved()
        default:
            break
        }
    }
    
    //MARK: 撤回后跳转到申请编辑器
    private func showEditVCAfterRecall(){
        networkHandler.status.recallApply(withApplyId: applyId) { (resultCode, message, data) in
            DispatchQueue.main.async {
                guard resultCode == .success else{
                    self.notif(withTitle: message, closure: nil)
                    return
                }
                
                let editVC = UIStoryboard(name: "Edit", bundle: Bundle.main).instantiateViewController(withIdentifier: "edit") as! EditVC
                editVC.isRootEdit = true
                editVC.apply = self.apply
                editVC.applyId = self.applyId
                editVC.policyId = self.apply?.policyId ?? 0
                
                editVC.navigationItem.title = self.apply?.policyShortTitle
                if var viewControllers = self.navigationController?.viewControllers {
                    viewControllers.removeLast()
                    self.navigationController?.setViewControllers(viewControllers, animated: false)
                }
                self.navigationController?.show(editVC, sender: nil)
            }
        }
    }
    
    //MARK: 移除后跳转到申请编辑器
    private func showEditVCAfterRemove(){
        networkHandler.status.removeApply(withApplyId: applyId, closure: { (resultCode, message, data) in
            DispatchQueue.main.async {
                self.notif(withTitle: message, closure: nil)
                guard resultCode == .success else{
                    return
                }
                self.showEditVC()
            }
        })
    }
    
    //MARK: 直接跳转到申请编辑器
    private func showEditVC(){
        guard let apl = apply else {
            return
        }
        //判断是否有该申请 then 获取申请
        NetworkHandler.share().policy.existedApply(withPolicyId: apl.policyId, closure: { (resultCode, message, apply) in
            DispatchQueue.main.async {
                guard resultCode == .success else{  //登陆判断
                    self.login()
                    return
                }
                
                guard let apl = apply else{
                    //新建申请
                    let policyId = self.apply!.policyId
                    NetworkHandler.share().policy.addApply(withPolicyId: policyId){ (resultCode, message, apply) in
                        DispatchQueue.main.async {
                            guard resultCode == .success else{
                                self.notif(withTitle: message, closure: nil)
                                return
                            }
                            
                            if let apl = apply{
                                
                                let editVC = UIStoryboard(name: "Edit", bundle: Bundle.main).instantiateViewController(withIdentifier: "edit") as! EditVC
                                editVC.policyId = policyId
                                editVC.policy = nil
                                editVC.applyId = apl.id
                                //editVC.apply = apl(进入后重新获取)
                                editVC.isRootEdit = true
                                editVC.navigationItem.title = self.apply?.policyShortTitle
                                self.navigationController?.show(editVC, sender: nil)
                            }
                        }
                    }
                    return
                }
                
                //获取已有申请
                let editVC = UIStoryboard(name: "Edit", bundle: Bundle.main).instantiateViewController(withIdentifier: "edit") as! EditVC
                editVC.isRootEdit = true
                editVC.apply = apl
                editVC.applyId = apl.id
                editVC.policyId = apl.policyId
                
                editVC.navigationItem.title = apl.policyShortTitle
                self.navigationController?.show(editVC, sender: nil)
            }
        })
        
    }
    
    //MARK: 跳转到已完结页
    private func popAfterCancel(){
        networkHandler.rootEditor.cancelApply(withApplyId: applyId, closure: { (resultCode, message, data) in
            DispatchQueue.main.async {
                self.notif(withTitle: message, closure: nil)
                guard resultCode == .success else{
                    return
                }
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
    
    //MARK: 移除后返回
    private func popAfterRemoved(){
        networkHandler.status.removeApply(withApplyId: applyId, closure: { (resultCode, message, data) in
            DispatchQueue.main.async {
                self.notif(withTitle: message, closure: nil)
                guard resultCode == .success else{
                    return
                }
                self.navigationController?.popViewController(animated: true)
            }
        })
    }
}
