//
//  H+RootEditor.swift
//  gov_sdk
//
//  Created by YiGan on 13/10/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import Foundation
public class NWHRootEditor: NSObject {
    
    //MARK:- init ------------------------------------------------------------
    private static let __once = NWHRootEditor()
    public class func share() -> NWHRootEditor{
        return __once
    }
    
    //MARK: 提交申请
    public func submitApply(withApplyId applyId: Int, closure: @escaping (_ resultCode: ResultCode, _ message: String, _ data: Any?) -> ()){
        guard let account = localAccount, let password = localPassword else {
            closure(.failure, "未登录", nil)
            return
        }
        let dic: [String: Any] = [
            "applyId": applyId,
            "userId": account,
            "password": password
        ]
        
        Session.session(withAction: Actions.submitApply, withMethod: Method.post, withParam: dic, closure: closure)
    }
    
    //MARK: 取消申请
    public func cancelApply(withApplyId applyId: Int, closure: @escaping (_ resultCode: ResultCode, _ message: String, _ data: Any?) -> ()){
        guard let account = localAccount, let password = localPassword else {
            closure(.failure, "未登录", nil)
            return
        }
        let dic: [String: Any] = [
            "applyId": applyId,
            "userId": account,
            "password": password
        ]
        
        Session.session(withAction: Actions.cancelApply, withMethod: Method.post, withParam: dic, closure: closure)
    }
}
