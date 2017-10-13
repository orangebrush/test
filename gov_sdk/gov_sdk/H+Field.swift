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
    public var fromItemId = 0       //组或字段实例id
    public var image: UIImage?
}

public class NWHField: NSObject {
    
    //MARK:- init ------------------------------------------------------------
    private static let __once = NWHField()
    public class func share() -> NWHField{
        return __once
    }
    
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
            dic["itemInstance"] = instanceId
        }
        
        Session.session(withAction: Actions.saveField, withMethod: Method.post, withParam: dic, closure: closure)
    }
    
    public func saveFile(withSaveFileParams params: SaveFileParams, closure: @escaping (_ resultCode: ResultCode, _ message: String, _ data: (URL?, Int)?) -> ()){
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
            "fromItemId": "\(params.fromItemId)",
            "userId": account,
            "password": password
        ]
        
        if let instanceId = params.instanceId{
            dic["itemInstance"] = instanceId
        }
        
        Session.upload(image, withParams: dic) { (resultCode, message, data) in
            var tuple: (url: URL?, instanceId: Int) = (nil, 0)
            if let d = data as? [String: Any]{
                if let urlStr = d["url"] as? String{
                    tuple.url = URL(string: urlStr)
                }
                if let instanceId = d["id"] as? Int{
                    tuple.instanceId = instanceId
                }
            }
            closure(resultCode, message, tuple)
        }
    }
}
