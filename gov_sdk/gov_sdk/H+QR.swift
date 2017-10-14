//
//  H+QR.swift
//  gov_sdk
//
//  Created by YiGan on 14/10/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import Foundation
public class NWHQR: NSObject {
    
    //MARK:- init ------------------------------------------------------------
    private static let __once = NWHQR()
    public class func share() -> NWHQR{
        return __once
    }
    
    //MARK: 扫码登陆
    public func login(withUUID uuid: String, closure: @escaping Closure){
        guard let account = localAccount, let password = localPassword else {
            closure(.failure, "需手动初始登陆", nil)
            return
        }
        
        //sha1
        let dic: [String: Any] = [
            "userId": account,
            "password": password,
            "uuid": uuid
        ]
        
        Session.session(withAction: Actions.login, withMethod: Method.post, withParam: dic, closure: closure)
    }
    
    //MARK: 扫码下载
    public func download(withUUID uuid: String, withURL urlString: String, closure: @escaping Closure){
        guard let account = localAccount, let password = localPassword else {
            closure(.failure, "需手动初始登陆", nil)
            return
        }
        
        //sha1
        let dic: [String: Any] = [
            "userId": account,
            "password": password,
            "uuid": uuid,
            "url": urlString
        ]
        
        Session.session(withAction: Actions.download, withMethod: Method.post, withParam: dic, closure: closure)
    }
}
