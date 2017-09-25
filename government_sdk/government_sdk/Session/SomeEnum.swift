//
//  SomeEnum.swift
//  NetWorkSDK
//
//  Created by X Young. on 2017/9/20.
//  Copyright © 2017年 XinRui. All rights reserved.
//

import Foundation
import HandyJSON

/// 网络请求类型
///
/// - GET: GET
/// - POST: POST
/// - PUT: PUT
enum Method:String{
    
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    
}

/// 当前网络连接类型
///
/// - NotReachable: 网络不可用
/// - ReachableViaWWAN: 流量
/// - ReachableViaWiFi: Wifi
enum MobileNetType{
    case NotReachable
    case ReachableViaWWAN
    case ReachableViaWiFi
}


public enum ResultCode{
    case failure
    case success
}

/// 申请状态信息
public enum ApplyStatus:Int, HandyJSONEnum{
    
    // 填写中
    case ApplyStatus_1_New                         = 10 //- 新建0%
    case ApplyStatus_1_FillIning                   = 11 //- 填写中
    case ApplyStatus_1_Pending                     = 18 //- 待提交
    
    // 审核中
    case ApplyStatus_2_UnRead                      = 20 //- 未阅读
    case ApplyStatus_2_NotProcessed                = 21 //- 尚未处理
    case ApplyStatus_2_Interesting                 = 22 //- 感兴趣
    case ApplyStatus_2_NoConsider                  = 23 //- 不考虑
    case ApplyStatus_2_Reject                      = 29 // - 驳回 (包含自己取消的)
    
    // 线下
    case ApplyStatus_3_NoAppointDate               = 30 //- 尚未确定办理时间
    case ApplyStatus_3_HandleAppointDate           = 31 //- 已预约办理
    case ApplyStatus_3_ApprovedAppropriation       = 38 //- 批准拨款
    case ApplyStatus_3_RefusalAppropriation        = 39 //- 拒绝拨款
    
    // 已完结
    case ApplyStatus_4_Expired                     = 40 //- 政策自动过期    // 不展示
    case ApplyStatus_4_OffShelf                    = 41 //- 政策强行下架    // 不展示
    case ApplyStatus_4_Blacklist                   = 42 //- 拉黑中断
    case ApplyStatus_4_Interrupt                   = 49 //- 强行中断

    
}

/// 申请实例状态
public enum ApplyInstanceStatus:String, HandyJSONEnum{
    case Normal = "A" // 正常
    case Cancel = "C" // 取消
    case Remove = "R" // 移除
}


