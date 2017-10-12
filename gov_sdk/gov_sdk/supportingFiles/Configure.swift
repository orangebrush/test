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
    static let allNews              = "/news"                   //获取新闻
    static let allPolicy            = "/policy"                 //获取所有政策
    static let allApply             = "/apply"                  //获取申请列表
    static let allBookmark          = "/policy/bookmark"        //获取所有收藏政策
    static let registerCompany      = "/company/register"       //注册企业
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
}

//获取本地存储的账户与密码
public let userDefaults = UserDefaults.standard
public var localAccount: String? {
    return userDefaults.string(forKey: "account")
}
public var localPassword: String? {
    return userDefaults.string(forKey: "password")
}
