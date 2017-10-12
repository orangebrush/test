//
//  NetworkHandler.swift
//  government_sdk
//
//  Created by YiGan on 12/10/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import Foundation

//actions
struct NWHActions{
    static let allNews              = "/news"                   //获取新闻
    static let allPolicy            = "/policy"                 //获取所有政策
}

//method
struct NWHMethod{
    static let get = "GET"
    static let post = "POST"
    static let put = "PUT"
    static let delete = "DELETE"
}

//session回调类型
public typealias Closure = (_ resultCode: ResultCode, _ message: String, _ data: Any?) -> ()


//MARK:- 网络控制器
public class NetworkHandler: NSObject {
    
    //首页
    public lazy var home: NWHHome = {
        return NWHHome.share()
    }()
    
    
    
    
    //MARK:- init -----------------------------------------------------------------
    private static let __once = NetworkHandler()
    public class func share() -> NetworkHandler{
        return __once
    }
}
