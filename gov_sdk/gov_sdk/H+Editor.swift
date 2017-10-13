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
            "applyId": params.applyId,
            "componentId": params.componentId,
            "userId": account,
            "password": password
        ]
        
        if params.isInstance{                       //获取条目下内容
            if let groupId = params.groupId, let instanceId = params.instanceId{
                dic["groupId"] = groupId
                dic["instanceId"] = instanceId
                
                Session.session(withAction: Actions.getInstance, withMethod: Method.post, withParam: dic, closure: { (resultCode, message, data) in
                    var item: Item?
                    if let itemData = data as? [String: Any]{
                        item = DataEncode.item(withItemData: itemData)
                    }
                    closure(resultCode, message, item)
                })
            }
        }else{
            if let groupId = params.groupId{        //获取普通组下内容
                dic["groupId"] = groupId
                
                Session.session(withAction: Actions.getGroup, withMethod: Method.post, withParam: dic, closure: { (resultCode, message, data) in
                    var item: Item?
                    if let itemData = data as? [String: Any]{
                        item = DataEncode.item(withItemData: itemData)
                    }
                    closure(resultCode, message, item)
                })
            }else{                                  //获取组件下内容
                Session.session(withAction: Actions.getComponent, withMethod: Method.post, withParam: dic, closure: { (resultCode, message, data) in
                    var item: Item?
                    if let itemData = data as? [String: Any]{
                        item = DataEncode.item(withItemData: itemData)
                    }
                    closure(resultCode, message, item)
                })
            }
        }
    }
}
