//
//  Configure.swift
//  gov_sdk
//
//  Created by YiGan on 12/10/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import Foundation

//actions
struct Actions{
    //首页
    static let allNews              = "/news/page"              //获取新闻
    static let allPolicy            = "/policy/page"            //获取所有政策
    
    //我
    static let allApply             = "/apply/list"             //获取申请列表
    static let allBookmark          = "/policy/bookmark/list"   //获取所有收藏政策
    static let registerCompany      = "/company/register"       //注册企业
    
    //申请状态
    static let getApply             = "/apply"                  //获取单个申请
    static let recallApply          = "/apply/recall"           //撤回申请
    static let removeApply          = "/apply/remove"           //移除申请
    
    //材料清单
    static let allStuff             = "/apply/attachment/list"  //获取线下材料清单
    static let markStuff            = "/apply/attachment"       //标记线下材料完成情况
    
    //root编辑器
    static let submitApply          = "/apply/submit"           //提交申请
    static let cancelApply          = "/apply/cancel"           //取消申请
    
    //编辑器
    static let getComponent         = "/component"              //获取组件数据
    static let getGroup             = "/component/group"        //获取组内数据
    static let getInstance          = "/component/itemInstance" //获取条目内数据
    static let addInstance          = "/component/itemInstance/add"     //新建条目
    static let deleteInstance       = "/component/itemInstance/delete"  //删除条目
    static let rollInstance         = "/component/itemInstance/roll"    //调整条目排序
    
    //录入器
    static let saveField            = "/component/update"               //更新组件数据（普通）
    static let saveFile             = "/component/update/attachment"    //更新组件数据（图片）
    static let pullFieldList         = "/dictionary"                     //获取字典表
    static let pullFieldPriceList    = "/dictionary/prize"               //获取资助勾选选项
    
    //政策详情
    static let getPolicy            = "/policy"                 //获取政策
    static let applyExisted         = "/policy/apply"           //判断是否存在申请实例
    static let addApply             = "/apply/add"              //新建申请实例
    static let bookmark             = "/policy/bookmark"        //收藏或取消收藏,判断
    
    //用户
    static let userinfo             = "/user"                       //获取用户信息（可作为登陆判定）
    static let getVerifyCode        = "/user/register/verifyCode"   //获取验证码
    static let checkVerifyCode      = "/user/register/checkCode"    //校验验证码
    static let register             = "/user/register"              //注册
    static let getResetVerifyCode   = "/user/reset/verifyCode"      //获取找回密码验证码
    static let checkResetVerifyCode = "/user/reset/checkCode"       //校验找回密码验证码
    static let reset                = "/user/reset"                 //找回密码
    static let changePassword       = "/user/changePassword"        //修改密码
    
    //扫码
    static let login                = "/qrcode/login"               //扫码登陆
    static let download             = "/qrcode/download"            //扫码下载
}

//method
struct Method{
    static let get = "GET"
    static let post = "POST"
    static let put = "PUT"
    static let delete = "DELETE"
}

//session回调类型
public typealias Closure = (_ resultCode: ResultCode, _ message: String, _ data: Any?) -> ()


//code
public enum ResultCode{
    case failure
    case success
    case notCompany
}

//获取本地存储的账户与密码
public let userDefaults = UserDefaults.standard
public var localAccount: String? {
    return userDefaults.string(forKey: "account")
}
public var localPassword: String? {
    return userDefaults.string(forKey: "password")
}
public var originPassword: String? {
    return userDefaults.string(forKey: "originalPassword")
}


//账号密码验证
public let accountLength        = 11
public let passwordMaxLength    = 20
public let passwordMinLength    = 6
public let verifyCodeLength     = 4

//MARK:- 正则表达式
public struct Regex {
    let regex: NSRegularExpression?
    
    public init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    public func match(input: String) -> Bool {
        if let matches = regex?.matches(in: input, options: [], range: NSMakeRange(0, (input as NSString).length)) {
            return matches.count > 0
        }
        return false
    }
}

//判断密码是否合法
public func isPasswordLegal(withString string: String?) -> (isLegal: Bool, message: String) {
    //判断密码是否为空
    guard let password: String = string, !password.characters.isEmpty else{
        return (false, "密码不能为空")
    }
    
//    let count = password.characters.count
//    guard  count >= passwordMinLength, count <= passwordMaxLength  else {
//        return (false, "密码长度为\(passwordMinLength)~\(passwordMaxLength)之间")
//    }
    return (true, "")
}

//判断账号是否合法
public func isAccountLegal(withString string: String?) -> (isLegal: Bool, message: String) {
    //判断账号是否为空
    guard let account: String = string, !account.characters.isEmpty else {
        return (false, "账号不能为空")
    }
    
    //判断账号是否合法
    let mailPattern = "^1[0-9]{10}$"
    let matcher = Regex(mailPattern)
    guard matcher.match(input: account) else{
        return (false, "账号需为合法的手机号")
    }
    
    return (true, "")
}

//判断验证码是否合法
public func isVerifyCodeLegal(withString string: String?) -> (isLegal: Bool, message: String) {
    //判断验证码是否为空
    guard let verifyCode: String = string, !verifyCode.characters.isEmpty else{
        return (false, "验证码不能为空")
    }
    
    let count = verifyCode.characters.count
    guard  count == verifyCodeLength else {
        return (false, "验证码长度为\(verifyCodeLength)")
    }
    return (true, "")
}
