//
//  CGFloat+Extension.swift
//  government_park
//
//  Created by YiGan on 19/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
extension CGFloat {
    
    //边距
    static let edge8: CGFloat = 8
    static let edge16: CGFloat = 16
    
    //圆角
    static let cornerRadius: CGFloat = 8
    
    //控件
    static let labelHeight: CGFloat = 21                        //标签高度
    static let buttonHeight: CGFloat = 30                       //按钮高度
    static let imageHeight: CGFloat = 88                        //图片高度
    static let cellHeight: CGFloat = 44                         //cell高度
    
    //段高度
    static let field0: CGFloat = 8 + 21 + 8 + 21 + 8            //短文本       66
    static let field1: CGFloat = 8 + 21 + 8 + 21 + 8            //长文本       66
    static let field2: CGFloat = 8 + 21 + 8 + 88 + 8            //图片        133
    static let field3: CGFloat = 8 + 21 + 8 + 21 + 8            //附件        66
    static let field4: CGFloat = 8 + 21 + 8 + 21 + 8            //单选        66
    static let field5: CGFloat = 8 + 21 + 8 + 21 + 8            //联动        66
    static let field6: CGFloat = 8 + 21 + 8 + 21 + 8            //多选        66
    
    //组高度
    static let group0: CGFloat = 8 + 21 + 8 + 30 + 8            //普通组       75
    static let group1: CGFloat = 8 + 21 + 8 + 30 + 8 + 30 + 8   //时间组       113
    static let group2: CGFloat = 8 + 21 + 8 + 30 + 8 + 30 + 8   //多条组less   113
    static let group3: CGFloat = 8 + 21 + 8 + 21 + 8 + 88 + 8   //图片组       162
    
    //我的申请状态高度
    static let state0: CGFloat = 8 + 21 + 8 + 21 + 8 + 21 + 21 + 8  //状态cell高度  116
}
