//
//  H+Me.swift
//  gov_sdk
//
//  Created by YiGan on 12/10/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import Foundation
import CoreLocation

//申请相关
public enum ApplyStatus: Int{
    //public enum Uncommitted: Int{           //未提交
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
    //}
}
public enum InstanceStatus: String{
    case normal = "A"
    case cancel = "C"
}
public class GovernmentContact: NSObject{
    public var name: String?
    public var phone: String?
}
public class Appointment: NSObject{ //预约线下办理时间
    public var applyId = 0
    public var address: String?
    public var location: CLLocationCoordinate2D?
    public var appointDate: Date?
    public var governmentContact: GovernmentContact?
}
public class Apply: NSObject{    //所有申请
    public var id = 0
    public var policyId = 0
    public var policyShortTitle: String?
    public var applyStatus: ApplyStatus?
    public var instanceStatus: InstanceStatus?
    public var lastUpdateDate: Date?        //最后更新时间
    public var dateHint: String?
    public var statusHint: String?
    public var date: Date?                  //提交时间
    public var appointment: Appointment?    //预约线下办理信息
    public var reason: String?              //驳回／中断原因
    public var cancelDate: Date?            //取消时间
    public var finished: Int = 0            //材料完成度
    public var attachmentFinished: Int = 0  //线下材料完成度
}

//注册企业相关
public class RegisterCompanyParams: NSObject{
    public var name: String?
    public var orgCode: String?     //统一信用代码
    public var file: UIImage?       //营业执照照片
}

public class NWHMe: NSObject {
    
    
    //MARK:- init ------------------------------------------------------------
    private static let __once = NWHMe()
    public class func share() -> NWHMe{
        return __once
    }
    
    //MARK: 获取申请列表
    public func getAllApply(closure: @escaping (_ resultCode: ResultCode, _ message: String, _ data: [Apply]?) -> ()){
        guard let account = localAccount, let password = localPassword else {
            closure(.failure, "未登录", nil)
            return
        }
        let dic = [
            "userID": account,
            "password": password
        ]
        Session.session(withAction: Actions.allApply, withMethod: Method.get, withParam: dic) { (resultCode, message, data) in
            
            var allApplyDataList = [Apply]()
            if let dList = data as? [[String: Any]]{
                for d in dList{
                    let allApplyData = Apply()
                    if let id = d["id"] as? Int{
                        allApplyData.id = id
                    }
                    if let policyId = d["policyId"] as? Int{
                        allApplyData.policyId = policyId
                    }
                    allApplyData.policyShortTitle = d["policyShortTitle"] as? String
                    if let applyStatusRawvalue = d["applyStatus"] as? Int{
                        allApplyData.applyStatus = ApplyStatus(rawValue: applyStatusRawvalue)
                    }
                    if let instanceStatusRawvalue = d["instanceStatus"] as? String{
                        allApplyData.instanceStatus = InstanceStatus(rawValue: instanceStatusRawvalue)
                    }
                    if let lastUpdateAt = d["lastUpdateAt"] as? Int{
                        allApplyData.lastUpdateDate = TimeInterval(lastUpdateAt).date()
                    }
                    allApplyData.dateHint = d["dateHint"] as? String
                    allApplyData.statusHint = d["statusHint"] as? String
                    if let applyAt = d["applyAt"] as? Int{
                        allApplyData.date = TimeInterval(applyAt).date()
                    }
                    if let appointmentData = d["appointment"] as? [String: Any]{
                        let appointment = Appointment()
                        if let applyId = appointmentData["applyId"] as? Int{
                            appointment.applyId = applyId
                        }
                        appointment.address = appointmentData["address"] as? String
                        if let locationStr = appointmentData["location"] as? String{
                            let longtitud = NSString(string: locationStr).doubleValue
                            let latitude = NSString(string: locationStr).doubleValue
                            let coor = CLLocationCoordinate2D(latitude: latitude, longitude: longtitud)
                            appointment.location = coor
                        }
                        if let appointDate = appointmentData["appointDate"] as? Int{
                            appointment.appointDate = TimeInterval(appointDate).date()
                        }
                        if let governmentContactData = appointmentData["governmentContact"] as? [String: String]{
                            let governmentContact = GovernmentContact()
                            governmentContact.name = governmentContactData["name"]
                            governmentContact.phone = governmentContactData["phone"]
                            appointment.governmentContact = governmentContact
                        }
                        allApplyData.appointment = appointment
                    }
                    allApplyData.reason = d["reason"] as? String
                    if let cancelDate = d["cancelDate"] as? Int{
                        allApplyData.cancelDate = TimeInterval(cancelDate).date()
                    }
                    if let finished = d["finished"] as? Int{
                        allApplyData.finished = finished
                    }
                    if let attachmentFinished = d["attachmentFinished"] as? Int{
                        allApplyData.attachmentFinished = attachmentFinished
                    }
                    
                    allApplyDataList.append(allApplyData)
                }
            }
            closure(resultCode, message, allApplyDataList)
        }
    }
    
    //MARK: 获取收藏政策
    public func getBookmarkPolicy(withPolicyId policyId: Int? = nil, closure: @escaping (_ resultCode: ResultCode, _ message: String, _ data: [Policy]?) -> ()){
        guard let account = localAccount, let password = localPassword else {
            closure(.failure, "未登录", nil)
            return
        }
        var dic: [String: Any] = [
            "userID": account,
            "password": password
        ]
        if let id = policyId{
            dic["policyId"] = id
        }
        Session.session(withAction: Actions.allBookmark, withMethod: Method.get, withParam: dic) { (resultCode, message, data) in
            
            var policyList = [Policy]()
            if let results = data as? [[String: Any]]{
                for result in results{
                    let policy = Policy()
                    if let id = result["id"] as? Int{
                        policy.id = id
                    }
                    policy.shortTitle = result["shortTitle"] as? String
                    policy.longTitle = result["longTitle"] as? String
                    if let smallPicStr = result["smallPic"] as? String{
                        policy.smallPicUrl = URL(string: smallPicStr)
                    }
                    if let bigPicStr = result["bigPic"] as? String{
                        policy.bigPicUrl = URL(string: bigPicStr)
                    }
                    policy.summary = result["summary"] as? String
                    if let pulishAt = result["pulishAt"] as? Int{
                        policy.date = TimeInterval(pulishAt).date()
                    }
                    if let deadline = result["deadline"] as? Int{
                        policy.endDate = TimeInterval(deadline).date()
                    }
                    if let applyTos = result["applyTo"] as? [[String: Any]]{
                        let applicant = Applicant()
                        for applyTo in applyTos{
                            if let id = applyTo["id"] as? Int{
                                applicant.id = id
                            }
                            applicant.name = applyTo["target"] as? String
                            applicant.detailText = applyTo["description"] as? String
                        }
                        policy.applicantList.append(applicant)
                    }
                    policyList.append(policy)
                }
            }
            
            closure(resultCode, message, policyList)
        }
    }
    
    //MARK: 注册企业
    public func registerCompany(withParams params: RegisterCompanyParams, closure: @escaping (_ resultCode: ResultCode, _ message: String, _ data: Any?) -> ()){
        guard let account = localAccount, let password = localPassword else {
            closure(.failure, "未登录", nil)
            return
        }
        var dic: [String: Any] = [
            "userID": account,
            "password": password
        ]
        
        guard let name = params.name else {
            closure(.failure, "name is empty", nil)
            return
        }
        dic["name"] = name
        
        guard let orgCode = params.orgCode else {
            closure(.failure, "orgCode is empty", nil)
            return
        }
        dic["orgCode"] = orgCode
        
        guard let img = params.file else {
            closure(.failure, "file is empty", nil)
            return
        }
        
        Session.upload(img, withParams: dic) { (resultCode, message, data) in
            closure(resultCode, message, nil)
        }
    }
}
