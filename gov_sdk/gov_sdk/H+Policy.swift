//
//  H+Policy.swift
//  gov_sdk
//
//  Created by YiGan on 14/10/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import Foundation


public class NWHPolicy: NSObject {
    
    //MARK:- init ------------------------------------------------------------
    private static let __once = NWHPolicy()
    public class func share() -> NWHPolicy{
        return __once
    }
    
    //MARK: 获取政策详情
    public func getPolicy(withPolicyId policyId: Int, closure: @escaping (_ resultCode: ResultCode, _ message: String, _ policy: Policy?)->()){
        let dic = [
            "policyId": "\(policyId)"
        ]
        
        Session.session(withAction: Actions.getPolicy, withMethod: Method.get, withParam: dic) { (resultCode, message, data) in
            var policy: Policy?
            if let policyData = data as? [String: Any]{
                policy = DataEncode.policy(withPolicyData: policyData)
            }
            closure(resultCode, message, policy)
        }
    }
    
    //MARK: 判断政策下是否存在申请实例
    public func existedApply(withPolicyId policyId: Int, closure: @escaping (_ resultCode: ResultCode, _ message: String, _ policy: Apply?)->()){
        guard let account = localAccount, let password = localPassword else {
            closure(.failure, "未登录", nil)
            return
        }
        
        let dic: [String: Any] = [
            "policyId": "\(policyId)",
            "userId": account,
            "password": password
        ]

        Session.session(withAction: Actions.applyExisted, withMethod: Method.get, withParam: dic) { (resultCode, message, data) in
            var apply: Apply?
            if let applyData = data as? [String: Any]{
                apply = DataEncode.apply(withApplyData: applyData)
            }
            closure(resultCode, message, apply)
        }
    }
    
    //MARK: 判断是否已收藏政策
    public func isPolicyBookmarked(withPolicyId policyId: Int, closure: @escaping (_ resultCode: ResultCode, _ message: String, _ isBookmarked: Bool)->()){
        guard let account = localAccount, let password = localPassword else {
            closure(.failure, "未登录", false)
            return
        }
        
        let dic: [String: Any] = [
            "policyId": "\(policyId)",
            "userId": account,
            "password": password
        ]
        
        Session.session(withAction: Actions.bookmark, withMethod: Method.get, withParam: dic) { (resultCode, message, data) in
            var existed = false
            if let flag = data as? Bool{
                existed = flag
            }
            closure(resultCode, message, existed)
        }
    }
    
    //MARK: 新增申请实例
    public func addApply(withPolicyId policyId: Int, closure: @escaping (_ resultCode: ResultCode, _ message: String, _ apply: Apply?)->()){
        guard let account = localAccount, let password = localPassword else {
            closure(.failure, "未登录", nil)
            return
        }
        
        let dic: [String: Any] = [
            "policyId": "\(policyId)",
            "userId": account,
            "password": password
        ]
        
        Session.session(withAction: Actions.addApply, withMethod: Method.post, withParam: dic) { (resultCode, message, data) in
            var apply: Apply?
            if let applyData = data as? [String: Any]{
                apply = DataEncode.apply(withApplyData: applyData)
            }
            closure(resultCode, message, apply)
        }
    }
    
    //MARK: 标记政策（收藏or取消收藏）
    public func bookmarkPolicy(withPolicyId policyId: Int, isBookmark: Bool, closure: @escaping Closure){
        guard let account = localAccount, let password = localPassword else {
            closure(.failure, "未登录", nil)
            return
        }
        
        let dic: [String: Any] = [
            "policyId": "\(policyId)",
            "userId": account,
            "password": password,
            "bookmark": isBookmark
        ]
        
        Session.session(withAction: Actions.bookmark, withMethod: Method.post, withParam: dic, closure: closure)
    }
}
