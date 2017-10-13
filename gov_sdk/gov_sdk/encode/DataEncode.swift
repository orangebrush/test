//
//  DataEncode.swift
//  gov_sdk
//
//  Created by YiGan on 13/10/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import Foundation
import CoreLocation
class DataEncode {
    
    //MARK: 解析policy
    class func policy(withPolicyData policyData: [String: Any]) -> Policy{
        let policy = Policy()
        if let id = policyData["id"] as? Int{
            policy.id = id
        }
        policy.shortTitle = policyData["shortTitle"] as? String
        policy.longTitle = policyData["longTitle"] as? String
        if let smallPicStr = policyData["smallPic"] as? String{
            policy.smallPicUrl = URL(string: smallPicStr)
        }
        if let bigPicStr = policyData["bigPic"] as? String{
            policy.bigPicUrl = URL(string: bigPicStr)
        }
        policy.summary = policyData["summary"] as? String
        if let pulishAt = policyData["pulishAt"] as? Int{
            policy.date = TimeInterval(pulishAt).date()
        }
        if let deadline = policyData["deadline"] as? Int{
            policy.endDate = TimeInterval(deadline).date()
        }
        if let applyTos = policyData["applyTo"] as? [[String: Any]]{
            let applicant = Applicant()
            for applyTo in applyTos{
                if let id = applyTo["id"] as? Int{
                    applicant.id = id
                }
                applicant.name = applyTo["target"] as? String
                applicant.detailText = applyTo["description"] as? String
            }
            policy.applicantList.append(applicant)
        }
        
        return policy
    }
    
    
    //MARK: 解析apply
    class func apply(withApplyData applyData: [String: Any]) -> Apply{
        let apply = Apply()
        if let id = applyData["id"] as? Int{
            apply.id = id
        }
        if let policyId = applyData["policyId"] as? Int{
            apply.policyId = policyId
        }
        apply.policyShortTitle = applyData["policyShortTitle"] as? String
        if let applyStatusRawvalue = applyData["applyStatus"] as? Int{
            apply.applyStatus = ApplyStatus(rawValue: applyStatusRawvalue)
        }
        if let instanceStatusRawvalue = applyData["instanceStatus"] as? String{
            apply.instanceStatus = InstanceStatus(rawValue: instanceStatusRawvalue)
        }
        if let lastUpdateAt = applyData["lastUpdateAt"] as? Int{
            apply.lastUpdateDate = TimeInterval(lastUpdateAt).date()
        }
        apply.dateHint = applyData["dateHint"] as? String
        apply.statusHint = applyData["statusHint"] as? String
        if let applyAt = applyData["applyAt"] as? Int{
            apply.date = TimeInterval(applyAt).date()
        }
        if let appointmentData = applyData["appointment"] as? [String: Any]{
            let appointment = Appointment()
            if let applyId = appointmentData["applyId"] as? Int{
                appointment.applyId = applyId
            }
            appointment.address = appointmentData["address"] as? String
            if let locationStr = appointmentData["location"] as? String{
                let longtitud = NSString(string: locationStr).doubleValue
                let latitude = NSString(string: locationStr).doubleValue
                let coor = CLLocationCoordinate2D(latitude: latitude, longitude: longtitud)
                appointment.location = coor
            }
            if let appointDate = appointmentData["appointDate"] as? Int{
                appointment.appointDate = TimeInterval(appointDate).date()
            }
            if let governmentContactData = appointmentData["governmentContact"] as? [String: String]{
                let governmentContact = GovernmentContact()
                governmentContact.name = governmentContactData["name"]
                governmentContact.phone = governmentContactData["phone"]
                appointment.governmentContact = governmentContact
            }
            apply.appointment = appointment
        }
        apply.reason = applyData["reason"] as? String
        if let cancelDate = applyData["cancelDate"] as? Int{
            apply.cancelDate = TimeInterval(cancelDate).date()
        }
        if let finished = applyData["finished"] as? Int{
            apply.finished = finished
        }
        if let attachmentFinished = applyData["attachmentFinished"] as? Int{
            apply.attachmentFinished = attachmentFinished
        }
        //解析组件相关
        if let catalogsData = applyData["catalogs"] as? [[String: Any]]{
            for catalogData in catalogsData{
                let catalog = Catalog()
                if let id = catalogData["id"] as? Int{
                    catalog.id = id
                }
                catalog.title = catalogData["title"] as? String
                catalog.detailTitle = catalogData["description"] as? String
                if let componentsData = catalogData["components"] as? [[String: Any]]{
                    for componentData in componentsData{
                        let baseItem = BaseItem()
                        if let id = componentData["id"] as? Int{
                            baseItem.id = id
                        }
                        baseItem.title = componentData["title"] as? String
                        if let isOptional = componentData["optional"] as? Bool{
                            baseItem.isOptional = isOptional
                        }
                        if let statusRawvalue = componentData["status"] as? Int{
                            baseItem.status = BaseItemStatus(rawValue: statusRawvalue)
                        }
                        catalog.baseItemList.append(baseItem)
                    }
                }
                apply.catalogList.append(catalog)
            }
        }
        return apply
    }

    /*
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
     */
    //MARK: 解析item
    class func item(withItemData itemData: [String: Any]) -> Item{
        let item = Item()
        if let id = itemData["id"] as? Int{
            item.id = id
        }
        if let applyId = itemData["applyId"] as? Int{
            item.applyId = applyId
        }
        if let componentId = itemData["componentId"] as? Int{
            item.componentId = componentId
            item.isRoot = false
        }else{
            item.isRoot = true
        }
        item.instanceId = itemData["instanceId"] as? Int
        item.title = itemData["title"] as? String
        if let type = itemData["itemType"] as? String{
            
        }
        return item
    }
}
