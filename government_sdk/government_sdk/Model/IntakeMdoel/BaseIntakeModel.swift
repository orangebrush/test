//
//  File.swift
//  government_sdk
//
//  Created by X Young. on 2017/9/27.
//  Copyright © 2017年 YiGan. All rights reserved.
//

import Foundation
import HandyJSON

public class BaseExampleModel :HandyJSON{
    
    /// 是否选填
    public var optional:Bool?
    
    /// 组类型或字段类型
    public var type:Int?
    
    /// isGroup?
    public var isGroup:Bool?
    
    /// id
    public var id:Int?
    
    /// 标题
    public var title:String?
    
    /// 完成状态(-1：未完成； 0： 已完成；1：可选)
    public var status:Int?
    
    /// 提示信息
    public var hint:String?
    
    required public init() {}
}

/// 基础字段模型
public class BaseFieldModel:BaseExampleModel{
    
    required public init() {}
}

/// 基础组模型
public class BaseGroupModel:BaseExampleModel{
    
    /// 条目
    public var optionList:[Option]? = [Option]()
    
    /// 是否为根组(用于区分上传API)
    public var isRoot:Bool?
    
    /// applyId(用于拉取内容)
    public var applyId:Int?
    
    /// 组件的构成
    var items:[DataItems]? = [DataItems]()
    
    /// 二次处理的数据
    public var secondItems:[BaseExampleModel]? = [BaseExampleModel]()
    
    required public init() {}
}



public class Option:NSObject{
    
    /// 选项ID
    public var id:String?
    
    /// 选项标题
    public var title:String?
    
    /// 附加字段值?(申报金额:钱数 其他均为短文本)
    public var extraValue:String?
    
    /// -1：未完成； 0： 已完成；1：可选
    public var status:Int?
    
    /// 附加字段完成状态信息
    public var hint:String?
}
