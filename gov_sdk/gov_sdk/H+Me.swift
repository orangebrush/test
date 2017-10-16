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

public class Apply: NSObject{       //所有申请
    public var id = 0
    public var policyId = 0
    public var policyShortTitle: String?
    public var applyStatus: ApplyStatus?            //申请状态
    
    public var instanceStatus: InstanceStatus?      //操作状态
    public var lastUpdateDate: Date?        //最后更新时间
    public var dateHint: String?
    public var statusHint: String?          //状态描述信息
    public var date: Date?                  //提交时间
    public var appointment: Appointment?    //预约线下办理信息
    public var reason: String?              //驳回／中断原因
    public var cancelDate: Date?            //取消时间
    public var finished: Int = 0            //材料完成度
    public var attachmentFinished: Int = 0  //线下材料完成度
    
    
    public var catalogList = [Catalog]()    //申请表目录
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
            "userId": account,
            "password": password
        ]
        Session.session(withAction: Actions.allApply, withMethod: Method.get, withParam: dic) { (resultCode, message, data) in
            
            var applyList = [Apply]()
            if let dList = data as? [[String: Any]]{
                for applyData in dList{                    
                    let apply = DataEncode.apply(withApplyData: applyData)
                    applyList.append(apply)
                }
            }
            closure(resultCode, message, applyList)
        }
    }
    
    
    
    //MARK: 获取收藏政策
    public func getBookmarkPolicy(closure: @escaping (_ resultCode: ResultCode, _ message: String, _ data: [Policy]?) -> ()){
        guard let account = localAccount, let password = localPassword else {
            closure(.failure, "未登录", nil)
            return
        }
        let dic: [String: Any] = [
            "userId": account,
            "password": password
        ]
  
        Session.session(withAction: Actions.allBookmark, withMethod: Method.get, withParam: dic) { (resultCode, message, data) in
            
            var policyList = [Policy]()
            if let policyListData = data as? [[String: Any]]{
                for policyData in policyListData{
                    let policy = DataEncode.policy(withPolicyData: policyData)
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
            "userId": account,
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
