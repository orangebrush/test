//
//  Configure.swift
//  government_park
//
//  Created by YiGan on 18/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit

//尺寸
let view_size = UIScreen.main.bounds.size                   //屏幕大小
let new_size = CGSize(width: 100, height: 100 + 21 * 2 +  8)    //新闻大小

//navigation高度
var navigation_height: CGFloat?

//我的状态栏类别
enum ProgressType: Int {
    case offline = 0    //已进入线下办理
    case auditing       //审核中
    case editing        //正在填写在线申请材料
    case collected      //已收藏
    case finished       //已完结
    //获取对应cell高度
    func height() -> CGFloat {
        switch self {
        case .finished:
            return 88
        default:
            return .cellHeight
        }
    }
}


