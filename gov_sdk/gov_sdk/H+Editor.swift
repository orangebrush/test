//
//  H+Editor.swift
//  gov_sdk
//
//  Created by YiGan on 13/10/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import Foundation

public class ItemsParams: NSObject{
    public var applyId = 0
    public var componentId = 0
    public var isInstance = false
    public var groupId: Int?
    public var instanceId: Int?
}

public class AddInstanceParams: NSObject{
    public var componentId = 0
    public var applyId = 0
    public var groupId = 0
    public var instanceId: Int?
    public var instanceTitle = "unknown"        //新建的条目的名称
}
public class deleteInstanceParams: NSObject{
    public var componentId = 0
    public var applyId = 0
    public var groupId = 0
    public var instanceId = 0
}
public class rollInstanceParams: NSObject{
    public var componentId = 0
    public var applyId = 0
    public var groupId = 0
    public var instanceId = 0
    public var isUp = true
}


public class NWHEditor: NSObject {
    
    //MARK:- init ------------------------------------------------------------
    private static let __once = NWHEditor()
    public class func share() -> NWHEditor{
        return __once
    }
    
    //获取组件数据or获取组数据or获取条目数据
    public func getItems(withParams params: ItemsParams, closure: @escaping (_ resultCode: ResultCode, _ message: String, _ data: Item?) -> ()){
        guard let account = localAccount, let password = localPassword else {
            closure(.failure, "未登录", nil)
            return
        }
        
        var dic: [String: Any] = [
            "applyId": "\(params.applyId)",
            "componentId": "\(params.componentId)",
            "userId": account,
            "password": password
        ]
        
        if params.isInstance{                       //获取条目下内容
            if let groupId = params.groupId, let instanceId = params.instanceId{
                dic["groupId"] = "\(groupId)"
                dic["itemInstance"] = "\(instanceId)"
                
                Session.session(withAction: Actions.getInstance, withMethod: Method.get, withParam: dic, closure: { (resultCode, message, data) in
                    var item: Item?
                    if let itemData = data as? [String: Any]{
                        item = DataEncode.item(withItemData: itemData)
                    }
                    closure(resultCode, message, item)
                })
            }
        }else{
            if let groupId = params.groupId{        //获取普通组下内容
                dic["groupId"] = "\(groupId)"
                
                Session.session(withAction: Actions.getGroup, withMethod: Method.get, withParam: dic, closure: { (resultCode, message, data) in
                    var item: Item?
                    if let itemData = data as? [String: Any]{
                        item = DataEncode.item(withItemData: itemData)
                    }
                    closure(resultCode, message, item)
                })
            }else{                                  //获取组件下内容
                Session.session(withAction: Actions.getComponent, withMethod: Method.get, withParam: dic, closure: { (resultCode, message, data) in
                    var item: Item?
                    if let itemData = data as? [String: Any]{
                        item = DataEncode.item(withItemData: itemData)
                    }
                    closure(resultCode, message, item)
                })
            }
        }
    }
    
    //MARK: 新建条目
    public func addInstance(withAddInstanceParams params: AddInstanceParams, closure: @escaping (_ resultCode: ResultCode, _ message: String, _ data: (String, Int)?) -> ()){
        guard let account = localAccount, let password = localPassword else {
            closure(.failure, "未登录", nil)
            return
        }
        
        var dic: [String: Any] = [
            "applyId": "\(params.applyId)",
            "componentId": "\(params.componentId)",
            "groupId": "\(params.groupId)",
            "value": params.instanceTitle,
            "userId": account,
            "password": password
        ]
        if let instanceId = params.instanceId{
            dic["itemInstance"] = "\(instanceId)"
        }
        
        Session.session(withAction: Actions.addInstance, withMethod: Method.post, withParam: dic) { (resultCode, message, data) in
            var tuple: (title: String, instanceId: Int) = ("", 0)
            if let d = data as? [String: Any]{
                if let title = d["title"] as? String{
                    tuple.title = title
                }
                if let instanceId = d["id"] as? Int{
                    tuple.instanceId = instanceId
                }
            }
            closure(resultCode, message, tuple)
        }
    }
    
    //MARK: 删除条目
    public func deleteInstance(withDeleteInstanceParams params: deleteInstanceParams, closure: @escaping Closure){
        guard let account = localAccount, let password = localPassword else {
            closure(.failure, "未登录", nil)
            return
        }
        
        let dic: [String: Any] = [
            "applyId": "\(params.applyId)",
            "componentId": "\(params.componentId)",
            "groupId": "\(params.groupId)",
            "itemInstance": "\(params.instanceId)",
            "userId": account,
            "password": password
        ]
        
        Session.session(withAction: Actions.deleteInstance, withMethod: Method.post, withParam: dic, closure: closure)
    }
    
    //MARK: 调整条目顺序
    public func rollInstance(withRollInstanceParams params: rollInstanceParams, closure: @escaping Closure){
        guard let account = localAccount, let password = localPassword else {
            closure(.failure, "未登录", nil)
            return
        }
        
        let dic: [String: Any] = [
            "applyId": "\(params.applyId)",
            "componentId": "\(params.componentId)",
            "groupId": "\(params.groupId)",
            "itemInstance": "\(params.instanceId)",
            "userId": account,
            "password": password,
            "up": params.isUp
        ]
        Session.session(withAction: Actions.rollInstance, withMethod: Method.post, withParam: dic, closure: closure)
    }
}
