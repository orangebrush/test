//
//  ComponentModel.swift
//  government_sdk
//
//  Created by X Young. on 2017/9/27.
//  Copyright © 2017年 YiGan. All rights reserved.
//

import Foundation
import HandyJSON



//MARK: 2.0 组/条目数据模型
public class ComponentGroupDataModel:HandyJSON{
    
    /// 申请实例ID
    public var applyId:Int?
    
    /// 组件ID
    public var componentId:Int?
    
    /// 组ID
    public var id:Int?
    
    /// 条目实例ID（如果是条目数据才有此属性，普通组无此属性）
    public var instanceId:Int?
    
    /// 组件路径(单位基本情况 / 企业人员情况 / 股东状况 / 张三)
    public var title:String?
    
    /// 组件的构成
    public var items:[DataItems]? = [DataItems]()
    
    /// 二次处理的数据
    public var secondItems:[BaseExampleModel]? = [BaseExampleModel]()
    
    required public init() {}
    
    public func didFinishMapping() {
        
    }
}


//MARK: 2.5 具体数据
public class DataItems:HandyJSON{
    
    /// 类型：组(G)、字段(F)
    public var itemtype:String?
    
    /// 组/字段Id
    public var id:Int?
    
    /// 组或字段标题
    public var title:String?
    
    /// -1：未完成（空心圆）； 0： 已完成（实心圆）；1：可选（虚框圆）
    public var status:Int?
    
    /// 组或字段值?
    public var value:Any?
    
    /// 完成状态提示信息（如：需填写、需上传附件、选填、20万元、我的简历.docx，等等）
    public var hint:String?
    
    /// 类型(组?)
    public var groupType:String?
    
    /// 最大条目数(多条组 / 多条图片组)
    public var maxItem:Int?
    
    /**************以下为时间点(段)组专属*******************/
    
    /// 时间精度: 年(Y)、半年(H)、季度(S)、月(M)
    public var itemUnit:String?
    
    /// 时间点数量或时间段跨度
    public var itemNumber:Int?
    /**********************************************/

    /// 类型(字段?)
    public var fieldType:Int?
    
    /// 字段位数限制
    public var maxLength:Int?
    
    /// 字段前缀
    public var fieldPrefix:String?
    
    /// 字段后缀
    public var fieldSuffix:String?
    
    required public init() {}

}

//MARK: 3.0 新建条目实例请求参数
public class NewsEntryComponent: NSObject{
    
    /// (可选）具体条目ID（保存具体条目实例数据时必填）
    public var itemInstance: Int?
    
    /// 多条组ID
    public var formItemId: Int?
    
    /// 条目名称
    public var value: String?
    
    public override init() {
        super.init()
    }
}

//MARK: 4.0 图片/附件上传的返回值
public class ReturnUploadImage: HandyJSON{
    
    /// 新增的图片条目实例ID（如果是多条图片组的话）
    public var id: Int?
    
    /// 新上传图片/附件的url
    public var title: String?
    
    required public init() {}
}
