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
    static let allNews              = "/news"                   //获取新闻
    static let allPolicy            = "/policy"                 //获取所有政策
    
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
    
    //政策详情
    static let getPolicy            = "/policy"                 //获取政策
    static let applyExisted         = "/policy/apply"           //判断是否存在申请实例
    //static let applyBookmark        = "/policy/bookmark"        //判断企业是否收藏该政策
    static let addApply             = "/apply/add"              //新建申请实例
    static let bookmark             = "/policy/bookmark"        //收藏或取消收藏,判断
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
