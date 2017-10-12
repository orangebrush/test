//
//  TimeIntakeModel.swift
//  government_sdk
//
//  Created by X Young. on 2017/9/27.
//  Copyright © 2017年 YiGan. All rights reserved.
//

import Foundation

public class TimeGroupModel: BaseGroupModel {
    
    
    /// 时间精度: 年(Y)、半年(H)、季度(S)、月(M)
    public var itemUnit: String?
    
    /// 时间点数量或时间段跨度
    public var itemNumber: Int?
}
