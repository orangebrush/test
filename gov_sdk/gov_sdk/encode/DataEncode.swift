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
                        baseItem.isGroup = true         //组件默认为组
                        baseItem.groupType = .normal    //组件类型默认为普通类型
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
            if type == "G"{         //组
                item.isGroup = true
                if let groupType = itemData["groupType"] as? String{
                    item.groupType = ItemType.GroupType(rawValue: groupType)
                }
            }else if type == "F"{   //字段
                item.isGroup = false
                if let fieldType = itemData["fieldType"] as? Int{
                    switch fieldType{
                    case 1210, 1220, 1241, 1243, 1244, 1245, 1246, 1247:        //短文本
                        item.fieldType = .short
                    case 1110, 1120:                                            //长文本
                        item.fieldType = .long
                    case 2000:                                                  //图片
                        item.fieldType = .image
                    case 3100:                                                  //附件
                        item.fieldType = .enclosure
                    case 9110, 9120, 9130:                                      //单选
                        item.fieldType = .single
                    case 9310, 9320, 9330, 9340, 9350:                          //多选
                        item.fieldType = .multi
                    case 9210:                                                  //联动
                        item.fieldType = .linkage
                    default:                                                    //时间
                        item.fieldType = .time
                    }
                }
            }
        }
        item.instanceId = itemData["instanceId"] as? Int
        if let isOptional = itemData["optional"] as? Bool{
            item.isOptional = isOptional
        }
        if let statusRawvalue = itemData["status"] as? Int{
            item.status = BaseItemStatus(rawValue: statusRawvalue)
        }
        item.hint = itemData["hint"] as? String
        if let maxItem = itemData["maxItem"] as? Int{
            item.maxValueCount = maxItem
        }
        if let unit = itemData["itemUnit"] as? String{
            item.unit = InstanceUnit(rawValue: unit)
        }
        if let number = itemData["itemNumber"] as? Int{
            item.number = number
        }
        if let maxLength = itemData["maxLength"] as? Int{
            item.maxLength = maxLength
        }
        item.prefix = itemData["fieldPrefix"] as? String
        item.suffix = itemData["fieldSuffix"] as? String
        if let valuesData = itemData["value"] as? [[String: Any]]{
            for valueData in valuesData{
                let value = DataEncode.value(withValueData: valueData)
                item.valueList.append(value)
            }
        }else if let valueData = itemData["value"] as? [String: Any]{
            let value = DataEncode.value(withValueData: valueData)
            item.valueList.append(value)
        }
        if let baseItemsData = itemData["items"] as? [[String: Any]]{
            for baseItemData in baseItemsData{
                let item = DataEncode.item(withItemData: baseItemData)
                item.baseItemList.append(item)
            }
        }
        return item
    }
    
    //MARK: 解析value
    class func value(withValueData valueData: [String: Any]) -> Value{
        let value = Value()
        if let id = valueData["id"] as? Int{
            value.id = id
        }
        value.title = valueData["title"] as? String
        if let statusRawvalue = valueData["status"] as? Int{
            value.status = BaseItemStatus(rawValue: statusRawvalue)
        }
        if let extrasValue = valueData["extraValue"] as? [[String: Any]]{
            for extraValue in extrasValue{
                let value = DataEncode.value(withValueData: extraValue)
                value.extraValue.append(value)
            }
        }else if let extraValue = valueData["extraValue"] as? [String: Any]{
            let value = DataEncode.value(withValueData: extraValue)
            value.extraValue.append(value)
        }
        value.hint = valueData["hint"] as? String
        return value
    }
}
