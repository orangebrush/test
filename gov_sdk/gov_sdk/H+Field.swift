//
//  H+Field.swift
//  gov_sdk
//
//  Created by YiGan on 13/10/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import Foundation

public class SaveFieldParams: NSObject{
    public var componentId = 0
    public var applyId = 0
    public var instanceId: Int?
    public var fieldId = 0
    public var value: Any?          //拼写字符串
}

public class SaveFileParams: NSObject{
    public var componentId = 0
    public var applyId = 0
    public var instanceId: Int?
    ///组或字段id
    public var fromItemId = 0       //组或字段实例id
    public var image: UIImage?
}

public class ExtraField: NSObject{
    public var title: String?
    public var fieldTypeValue: Int?
    public var maxLength: Int?          //值长度限制
    public var maxValue: Int?           //值大小限制
    public var prefix: String?          //资助勾选无此选项
    public var suffix: String?          //如果是资助勾选则固定显示万元万元
}
public class Option: NSObject{  //选项
    //单选
    public var id = 0                   //选项值
    public var title: String?           //标题选项
    //联动选项(专属)
    public var optionList = [Option]()  //层级
    //多选+附加字段(专属)
    public var extraField: ExtraField?  //附加属性
}
//public class Content: NSObject{ //字典表
//    public var id = 0
//    public var title: String?
//    public var optionList = [Option]()  //联动
//}

public class NWHField: NSObject {
    
    //MARK:- init ------------------------------------------------------------
    private static let __once = NWHField()
    public class func share() -> NWHField{
        return __once
    }
    
    //MARK: 提交字段
    public func saveField(withSaveFieldParams params: SaveFieldParams, closure: @escaping Closure){
        guard let account = localAccount, let password = localPassword else {
            closure(.failure, "未登录", nil)
            return
        }
        
        //拼写成字符串
        guard let val = params.value else {
            return
        }
        
        var dic: [String: Any] = [
            "applyId": "\(params.applyId)",
            "componentId": "\(params.componentId)",
            "fieldId": "\(params.fieldId)",
            "userId": account,
            "password": password,
            "value": val
        ]
        
        if let instanceId = params.instanceId{
            dic["itemInstance"] = "\(instanceId)"
        }
        
        Session.session(withAction: Actions.saveField, withMethod: Method.post, withParam: dic, closure: closure)
    }
    
    //MARK: 提交图片
    public func saveFile(withSaveFileParams params: SaveFileParams, closure: @escaping (_ resultCode: ResultCode, _ message: String, _ data: (String?, Int)?) -> ()){
        guard let account = localAccount, let password = localPassword else {
            closure(.failure, "未登录", nil)
            return
        }
        
        guard let image = params.image else {
            closure(.failure, "需上传图片", nil)
            return
        }
        
        var dic: [String: Any] = [
            "applyId": "\(params.applyId)",
            "componentId": "\(params.componentId)",
            "formItemId": "\(params.fromItemId)",
            "userId": account,
            "password": password
        ]
        
        if let instanceId = params.instanceId{
            dic["itemInstance"] = "\(instanceId)"
        }
        
        Session.upload(image, withAction: Actions.saveFile, withParams: dic) { (resultCode, message, data) in
            var tuple: (urlStr: String?, instanceId: Int) = (nil, 0)
            if let d = data as? [String: Any]{
                tuple.urlStr = d["title"] as? String
                if let instanceId = d["id"] as? Int{
                    tuple.instanceId = instanceId
                }
            }
            closure(resultCode, message, tuple)
        }
    }
    
    //MARK: 下拉选项列表
    public func pullOptionList(withFieldTypeValue fieldTypeValue: Int, closure: @escaping (_ resultCode: ResultCode, _ message: String, _ optionList: [Option])->()){
        let dic = ["fieldType": "\(fieldTypeValue)"]
        Session.session(withAction: Actions.pullFieldList, withMethod: Method.get, withParam: dic) { (resultCode, message, data) in
            var optionList = [Option]()
            if let optionListData = data as? [[String: Any]]{
                for optionData in optionListData{
                    let option = DataEncode.option(withOptionData: optionData)
                    optionList.append(option)
                }
            }
            closure(resultCode, message, optionList)
        }
    }
    
    //MARK: 下拉资助列表
    public func pullPrizeList(withPolicyId policyId: Int, closure: @escaping (_ resultCode: ResultCode, _ message: String, _ optionList: [Option])->()){
        let dic = ["policyId": "\(policyId)"]
        Session.session(withAction: Actions.pullFieldPriceList, withMethod: Method.get, withParam: dic) { (resultCode, message, data) in
            var optionList = [Option]()
            if let optionListData = data as? [[String: Any]]{
                for optionData in optionListData{
                    let option = DataEncode.option(withOptionData: optionData)
                    optionList.append(option)
                }
            }
            closure(resultCode, message, optionList)
        }
    }
}
