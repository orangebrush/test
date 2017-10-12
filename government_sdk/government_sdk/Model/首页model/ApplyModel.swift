//
//  ApplyModel.swift
//  government_sdk
//
//  Created by X Young. on 2017/9/26.
//  Copyright © 2017年 YiGan. All rights reserved.
//

import Foundation
import HandyJSON

//MARK: 1.0 申请首页入口模型
public class ApplyInstance: HandyJSON {
    
    /// 申请实例ID
    public var id:Int?
    
    /// 政策ID
    public var policyId:Int?
    
    /// 政策短标题
    public var policyShortTitle:String?
    
    /// 资料完成度
    public var finished:Int?
    
    /// 状态描述信息
    public var statusHint:String?

    /// 申请表与所申报资助表信息
    public var catalogs:[ApplyCatalogs]? = [ApplyCatalogs]()
    
    ///// 所申报资助
    //public var prizeCatalog:[PrizeCatalog]!
    
    required public init() {}
}

//MARK: 1.1 申请表信息
public class ApplyCatalogs: HandyJSON {
    
    /// 目录id
    public var id:Int?
    
    /// 目录标题
    public var title:String?
    
    /// 目录说明
    public var description:String?
    
    /// 组件
    public var components:[BaseGroupModel]? = [BaseGroupModel]()
    
    //组 或者 字段实例
    public var secondItems: [BaseExampleModel]? = [BaseExampleModel]()
    
    required public init() {}
}

////MARK: 1.1.1 组件
//public class RootGroup: BaseGroupModel, HandyJSON{
//
//
//    required public init() {}
//}

//MARK: 1.2 所申报资助
public class PrizeCatalog: HandyJSON {
    
    /// 目录id
    public var id:Int?
    
    /// 目录标题
    public var title:String?
    
    /// 是否已在"申报概要"组件下"所申报资助"中勾选此资助
    public var selected:Bool?
    
    /// 资助组件
    public var catalogs:[BaseGroupModel]? = [BaseGroupModel]()
    
    required public init() {}
}


