//
//  LongTextModel.swift
//  government_sdk
//
//  Created by X Young. on 2017/9/28.
//  Copyright © 2017年 YiGan. All rights reserved.
//

import Foundation

public class LongTextModel: BaseExampleModel {
    
    /// 是否有换行符 (单段?多段?)
    public var isWrap : Bool?
    
    /// 字数限制.
    public var maxLength : Int?
    
    
}
