//
//  BaseIntakeModel.swift
//  NetWorkSDK
//
//  Created by X Young. on 2017/9/19.
//  Copyright © 2017年 XinRui. All rights reserved.
//

import UIKit

class BaseIntakeModel: NSObject {

    /// 是否选填
    var isMustWrite : Bool!
    
    /// 完成度
    var finnishLevel: Float?{
        didSet{
            
            if !isMustWrite {
                finnishLevel = nil
            }
        }

    }
    
    // 字段名
    var title : String!
    
    // id
    var id : String!
    
    
    
}

