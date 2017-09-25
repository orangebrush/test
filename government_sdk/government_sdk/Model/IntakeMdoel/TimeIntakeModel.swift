//
//  TimeIntakeModel.swift
//  NetWorkSDK
//
//  Created by X Young. on 2017/9/19.
//  Copyright © 2017年 XinRui. All rights reserved.
//

import UIKit
// FIXME:待与钟哥讨论之后确定模型
class TimeIntakeModel: BaseIntakeModel {

    /// 下一层级时间点的集合
    var shortTextModelMArray = [[ShortTextModel] ]()
    
    /// 时间点
    var timesTitleMArray = [String](){
        didSet{
            for timePoint in timesTitleMArray {
                
                let singleShortTextModel = ShortTextModel()
                singleShortTextModel.title = timePoint
                
                
            }
            
        }
        
    }
}
