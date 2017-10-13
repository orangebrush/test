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
    public lazy var home: NWHHome = {
        return NWHHome.share()
    }()
    
    //我的
    public lazy var me: NWHMe = {
        return NWHMe.share()
    }()
    
    //申请状态
    public lazy var status: NWHStatus = {
        return NWHStatus.share()
    }()
    
    //MARK:- init -----------------------------------------------------------------
    private static let __once = NetworkHandler()
    public class func share() -> NetworkHandler{
        return __once
    }
}
