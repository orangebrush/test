//
//  H+Base.swift
//  gov_sdk
//
//  Created by YiGan on 13/10/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import Foundation


//组类型
public enum ItemType{
    public enum GroupType: String{
        case normal     = "C"       //普通组
        case time       = "T"       //时间段组
        case multi      = "M"       //多条组
        case image      = "U"       //图片组
        case timepoint  = "P"       //时间点组
        
        //获取组高度
        public func height() -> CGFloat{
            switch self {
            case .normal:
                return .group0
            case .time:
                return .group1
            case .multi:
                return .group2
            case .image:
                return .group3
            case .timepoint:
                return .group1
            }
        }
        
        //获取identify
        public func identifier() -> String{
            switch self {
            case .normal:
                return "group0"
            case .time:
                return "group1"
            case .multi:
                return "group2"
            case .image:
                return "group3"
            case .timepoint:
                return "group1"
            }
        }
    }
    
    //字段实例类型
    public enum FieldType: Int{
        case short = 0      //短文本
        case long           //长文本
        case image          //图片
        case enclosure      //附件
        case single         //单选
        case multi          //多选
        case linkage        //联动选择
        case time           //时间
        //获取段高度
        public func height() -> CGFloat{
            switch self {
            case .short:
                return .field0
            case .long:
                return .field1
            case .image:
                return .field2
            case .enclosure:
                return .field3
            case .single:
                return .field4
            case .multi:
                return .field6
            case .time:
                return .field7
            default:
                return .field5
            }
        }
        
        //获取identifier
        public func identifier() -> String{
            switch self {
            case .short:
                return "field0"
            case .long:
                return "field1"
            case .image:
                return "field2"
            case .enclosure:
                return "field3"
            case .single:
                return "field4"
            case .multi:
                return "field6"
            case .time:
                return "field7"
            default:
                return "field5"
            }
        }
    }
}





//组或字段实例完成度类型
public enum BaseItemStatus: Int{
    case unfinished = -1                    //未完成
    case finished   = 0                     //已完成
    case each       = 1                     //可选
}

//组或字段简略显示值
public class Value: NSObject{
    public var id = 0
    public var title: String?
    public var status: BaseItemStatus?
}

public enum InstanceUnit: String{
    case year       = "Y"                   //年
    case halfYear   = "H"                   //半年
    case season     = "S"                   //季度
    case month      = "M"                   //月
}

//统一的组与字段实例(基础item)
public class BaseItem: NSObject{
    //区分是否为组或字段实例
    public var type: ItemType?
    
    
    public var id = 0                              //组或字段实例id
    public var instanceId: Int?                    //条目id
    public var title: String?                      //标题(路径)
    public var isOptional = false                  //可选or必选
    public var status: BaseItemStatus?             //完成状态
    public var hint: String?                       //完成提示
    
    //多条组、多条图片组、。。。
    public var valueList = [Value]()               //条目(多条组条目信息，字段内容信息)
    public var maxValueCount = 0                   //最大条目数(多条组，多条图片组)
    
    //时间点组...
    public var unit: InstanceUnit?                 //单位
    public var number: Int = 0                     //值
    
    //字段
    public var maxLength = 0                       //位数限制
    public var prefix: String?
    public var suffix: String?
}

//组或组件或字段实例
public class Item: BaseItem{
    public var isRoot = false                       //判断是否为组件
    public var applyId = 0                          //申请id
    public var componentId: Int?                    //组件id(如果本身为组件，则等于id)
    public var baseItemList = [BaseItem]()
}


//目录
public class Catalog: NSObject{    
    public var id = 0                       //目录id
    public var title: String?               //目录标题
    public var detailTitle: String?         //描述标题
    public var baseItemList = [BaseItem]()
}

