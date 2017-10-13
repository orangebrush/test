//
//  H+Status.swift
//  gov_sdk
//
//  Created by YiGan on 13/10/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import Foundation
public class NWHStatus: NSObject {
    
    //MARK:- init ------------------------------------------------------------
    private static let __once = NWHStatus()
    public class func share() -> NWHStatus{
        return __once
    }
    
    //MARK: 获取单个申请
    public func getApply(withApplyId applyId: Int, closure: @escaping (_ resultCode: ResultCode, _ message: String, _ data: Apply?) -> ()){
        guard let account = localAccount, let password = localPassword else {
            closure(.failure, "未登录", nil)
            return
        }
        let dic: [String: Any] = [
            "applyId": applyId,
            "userId": account,
            "password": password
        ]
        
        Session.session(withAction: Actions.getApply, withMethod: Method.get, withParam: dic) { (resultCode, message, data) in
            var apply: Apply?
            if let applyData = data as? [String: Any]{
                apply = DataEncode.apply(withApplyData: applyData)
            }
            closure(resultCode, message, apply)
        }
    }
    
    //MARK: 撤回申请
    public func recallApply(withApplyId applyId: Int, closure: @escaping (_ resultCode: ResultCode, _ message: String, _ data: Any?) -> ()){
        guard let account = localAccount, let password = localPassword else {
            closure(.failure, "未登录", nil)
            return
        }
        let dic: [String: Any] = [
            "applyId": applyId,
            "userId": account,
            "password": password
        ]
        
        Session.session(withAction: Actions.recallApply, withMethod: Method.post, withParam: dic, closure: closure)
    }
    
    //MARK: 移除申请
    public func removeApply(withApplyId applyId: Int, closure: @escaping (_ resultCode: ResultCode, _ message: String, _ data: Any?) -> ()){
        guard let account = localAccount, let password = localPassword else {
            closure(.failure, "未登录", nil)
            return
        }
        let dic: [String: Any] = [
            "applyId": applyId,
            "userId": account,
            "password": password
        ]
        
        Session.session(withAction: Actions.removeApply, withMethod: Method.post, withParam: dic, closure: closure)
    }
}
