//
//  MyApplyListModel.swift
//  government_sdk
//
//  Created by X Young. on 2017/9/22.
//  Copyright © 2017年 YiGan. All rights reserved.
//

import Foundation
import HandyJSON


//MARK: 初次返回数据

//MARK: 1.0 我的申请列表处女数据
public class ApplyVirginModel: HandyJSON {
    
    /// 申请实例ID
    public var id:Int! = 0
    
    /// 政策ID
    public var policyId:Int! = 0
    
    /// 政策短标题
    public var policyShortTitle:String! = ""
    
    /// 分类申请状态
    public var kindApplyStatus:KindApplyStatus! = KindApplyStatus.Writing
    
    /// 详细申请状态
    public var instanceStatus:ApplyInstanceStatus?
    
    /// 时间跨度描述信息（如：“3天前”）
    public var dateHint:String! = ""
    
    /// 状态描述信息（如：“预约时间已过，结果如何？”、“必填资料完成度：100%”等等）
    public var statusHint:String! = ""
    
    /**************************************************************************/
    
    /// 申请状态
    public var applyStatus:DetailApplyStatus! = DetailApplyStatus.ApplyStatus_1_FillIning
    
    /// 申请提交时间
    public var applyAt:Int?
    
    /// 预约线下办理信息
    public var appointment:Appointment?
    
    /// 驳回/中断理由
    public var reason:String?
    
    /// 申请实例创建时间
    public var createAt:Int! = 0
    
    /// 资料完成度（填写申请中） 或 准备材料完成度（线下办理中）
    public var finished:Int?
    
    /// 线下材料完成度
    public var attachmentFinished:Int?
    
    required public init() {}
}

//MARK: 1.1 预约线下办理信息Appointment


public class Appointment: HandyJSON {
    
    public var address: String?
    public var appointDate: Int?
    public var governmentContact:[GovernmentContact]? = [GovernmentContact]()
    public var memo: String?
    
    required public init() {}
}

//MARK: 1.1.1 政府联系人
public class GovernmentContact: HandyJSON {
    
    public var name: String? // 姓名
    public var phone: String? // 联系电话
    
    required public init() {}
}

//MARK: 2.0 我的收藏政策列表处女数据
public class BookmarkPolicyVirginModel: HandyJSON {
    
    public var id:Int! = 0          // 政策ID
    public var title:String! =  ""   // 政策标题
    public var dateHint:String! = ""  // 时间跨度描述信息
    public var applyTo:[BookmarkPolicyApplyTo]! =  [BookmarkPolicyApplyTo]()// 扶持对象字符串
    
    required public init() {}
}

//MARK: 2.1 我的收藏政策扶持对象
public class BookmarkPolicyApplyTo: HandyJSON {
    
    public var id:Int! =    0          // 扶持对象id
    public var target: String! =   ""   // 扶持对象类型
    public var description: String! =   ""    // 扶持对象描述
    
    required public init() {}
}

