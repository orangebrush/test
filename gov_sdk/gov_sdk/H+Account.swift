//
//  H+Account.swift
//  gov_sdk
//
//  Created by YiGan on 12/10/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import Foundation

//用户状态
public enum UserStatus: String{
    case normal         = "A"           //正常
    case notCertified   = "U"           //未认证
    case auditing       = "C"           //审核中
    case refuse         = "F"           //被拒
}
public class Company: NSObject{
    public var id = 0                   //企业id
    public var name = ""                //企业名称
}
public class User: NSObject{
    public var id = 0                   //用户id
    public var account = ""             //用户名（手机号)
    public var status: UserStatus?      //用户状态
    public var company: Company?        //所在企业
}

public class NWHAccount: NSObject {
    
    //MARK:- init ------------------------------------------------------------
    private static let __once = NWHAccount()
    public class func share() -> NWHAccount{
        return __once
    }
    
    //MARK: 获取用户信息
    public func getUserinfo(closure: @escaping (_ resultCode: ResultCode, _ message: String, _ data: User?)->()){
        guard let account = localAccount, let password = localPassword else {
            closure(.failure, "未登录", nil)
            return
        }
        
        //sha1
        let dic: [String: Any] = [
            "userId": account,
            "password": password
        ]
        
        Session.session(withAction: Actions.userinfo, withMethod: Method.get, withParam: dic) { (resultCode, message, data) in
            let user = User()
            if let userData = data as? [String: Any]{
                if let id = userData["id"] as? Int{
                    user.id = id
                }
                if let loginName = userData["loginName"] as? String{
                    user.account = loginName
                }
                if let groupData = userData["group"] as? [String: Any]{
                    let company = Company()
                    if let id = groupData["id"] as? Int{
                        company.id = id
                    }
                    if let name = groupData["name"] as? String{
                        company.name = name
                    }
                    user.company = company
                }
                if let statusRawvalue = userData["status"] as? String{
                    user.status = UserStatus(rawValue: statusRawvalue)
                }
            }
            closure(resultCode, message, user)
        }
    }
    
    //MARK: 获取验证码
    public func getVerifyCode(withAccount account: String, closure: @escaping Closure){
        let tuple = isAccountLegal(withString: account)
        guard tuple.isLegal else {
            closure(.failure, tuple.message, nil)
            return
        }
        
        let dic = ["mobile": account]
        
        Session.session(withAction: Actions.getVerifyCode, withMethod: Method.post, withParam: dic, closure: closure)
    }
    
    //MARK: 校验验证码
    public func checkVerifyCode(withVerfiyCode verifyCode: String, closure: @escaping Closure){
        guard let account = localAccount else {
            closure(.failure, "未输入账号", nil)
            return
        }
        
        let tuple = isVerifyCodeLegal(withString: verifyCode)
        guard tuple.isLegal else {
            closure(.failure, tuple.message, nil)
            return
        }
        
        let dic: [String: Any] = [
            "moblie": account,
            "verifyCode": verifyCode
        ]
        
        Session.session(withAction: Actions.checkVerifyCode, withMethod: Method.post, withParam: dic, closure: closure)
    }
    
    //MARK: 注册
    public func register(withPassword password: String, closure: @escaping Closure){
        guard let account = localAccount else {
            closure(.failure, "未输入账号", nil)
            return
        }
        
        let tuple = isPasswordLegal(withString: password)
        guard tuple.isLegal else {
            closure(.failure, tuple.message, nil)
            return
        }
        
        //sha1
        let dic = [
            "moblie": account,
            "password": password
        ]
        
        Session.session(withAction: Actions.register, withMethod: Method.post, withParam: dic, closure: closure)
    }
    
    //MARK: 找回密码-获取验证码
    public func getResetVerifyCode(withAccount account: String, closure: @escaping Closure){
        let tuple = isAccountLegal(withString: account)
        guard tuple.isLegal else {
            closure(.failure, tuple.message, nil)
            return
        }
        
        let dic = ["mobile": account]
        
        Session.session(withAction: Actions.getResetVerifyCode, withMethod: Method.post, withParam: dic, closure: closure)
    }
    
    //MARK: 找回密码-校验验证码
    public func checkResetVerifyCode(withVerfiyCode verifyCode: String, closure: @escaping Closure){
        guard let account = localAccount else {
            closure(.failure, "未输入账号", nil)
            return
        }
        
        let tuple = isVerifyCodeLegal(withString: verifyCode)
        guard tuple.isLegal else {
            closure(.failure, tuple.message, nil)
            return
        }
        
        let dic: [String: Any] = [
            "moblie": account,
            "verifyCode": verifyCode
        ]
        
        Session.session(withAction: Actions.checkResetVerifyCode, withMethod: Method.post, withParam: dic, closure: closure)
    }
    
    //MARK: 找回密码-重置密码
    public func reset(withPassword password: String, closure: @escaping Closure){
        guard let account = localAccount else {
            closure(.failure, "未输入账号", nil)
            return
        }
        
        let tuple = isPasswordLegal(withString: password)
        guard tuple.isLegal else {
            closure(.failure, tuple.message, nil)
            return
        }
        
        //sha1
        let dic = [
            "moblie": account,
            "password": password
        ]
        
        Session.session(withAction: Actions.reset, withMethod: Method.post, withParam: dic, closure: closure)
    }
    
    //MARK: 修改密码
    public func changePassword(withNewPassword newPassword: String, closure: @escaping Closure){
        guard let account = localAccount, let password = localPassword else {
            closure(.failure, "未登录", nil)
            return
        }
        
        let tuple = isPasswordLegal(withString: newPassword)
        guard tuple.isLegal else {
            closure(.failure, tuple.message, nil)
            return
        }
        
        //sha1
        let dic: [String: Any] = [
            "userId": account,
            "password": password,
            "newPassword": newPassword
        ]
        
        Session.session(withAction: Actions.changePassword, withMethod: Method.post, withParam: dic, closure: closure)
    }
}
