//
//  Handler.swift
//  gov_sdk
//
//  Created by YiGan on 12/10/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import Foundation



//MARK:- 网络控制器
public class NetworkHandler: NSObject {
    
    //首页
    public lazy var home: NWHHome = {return NWHHome.share()}()
    //我的
    public lazy var me: NWHMe = {return NWHMe.share()}()
    //申请状态
    public lazy var status: NWHStatus = {return NWHStatus.share()}()
    //材料清单
    public lazy var attachment: NWHAttachment = {return NWHAttachment.share()}()
    //root编辑器
    public lazy var rootEditor: NWHRootEditor = {return NWHRootEditor.share()}()
    //编辑器
    public lazy var editor: NWHEditor = {return NWHEditor.share()}()
    //录入器
    public lazy var field: NWHField = {return NWHField.share()}()
    //政策详情
    public lazy var policy: NWHPolicy = {return NWHPolicy.share()}()
    //用户
    public lazy var account: NWHAccount = {return NWHAccount.share()}()
    //扫码
    public lazy var QR: NWHQR = {return NWHQR.share()}()
    

    //MARK:- init -----------------------------------------------------------------
    private static let __once = NetworkHandler()
    public class func share() -> NetworkHandler{
        return __once
    }
}
