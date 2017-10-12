//
//  userModel.swift
//  government_sdk
//
//  Created by X Young. on 2017/9/30.
//  Copyright © 2017年 YiGan. All rights reserved.
//

import Foundation
import HandyJSON

public class UsrInformationModel:  HandyJSON{
    
    /// 用户ID
    public var id:Int! = 0
    
    /// 用户登录名（手机号)
    public var loginName:String! = ""
    
    /// 用户所在企业名称
    public var group:CompanyInformationModel?

    /// 用户状态：正常账号（A）； 未认证账号（U）；注册企业审核中（C）； 注册企业被拒（F）
    public var status:String!
    
    
    required public init() {}
}

public class CompanyInformationModel:  HandyJSON{
    
    /// 公司ID
    public var id:Int! = 0
    
    /// 公司名字
    public var name:String! = ""
    
    
    required public init() {}
}
