//
//  NetworkHandler.swift
//  NetWorkSDK
//
//  Created by X Young. on 2017/9/21.
//  Copyright © 2017年 XinRui. All rights reserved.
//

import Foundation

/// 请求地址
enum Actions: String{
    
    // 政策新闻
    case pageNews                   = "/news"
    
    // 获取我的政策
    case myApplyList                = "/apply"
    
    // 获取我的收藏
    case myBookmarkPolicyList       = "/policy/bookmark"
    
    // 获取所有政策
    case getAllHomepagePolicy       = "/policy"
    
    // 根据政策id获取某个政策的详情
    case getDetailPolicy            = "/policy/"
    
    // 根据政策id获取其申请对象
    case getApplyWithPolicyId       = "/apply/policy/"
    
    
}

