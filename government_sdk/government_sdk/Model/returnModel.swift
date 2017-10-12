//
//  returnModel.swift
//  government_sdk
//
//  Created by X Young. on 2017/10/11.
//  Copyright © 2017年 YiGan. All rights reserved.
//

import Foundation
import HandyJSON

public class SessionResultModel: HandyJSON {
    
    /// code
    public var code:Int!
    
    /// message
    public var message:String!
    
    /// result
    public var result:AnyObject?
    
    required public init() {}
}
