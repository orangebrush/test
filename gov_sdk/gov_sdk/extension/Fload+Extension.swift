//
//  Fload+Extension.swift
//  gov_sdk
//
//  Created by YiGan on 13/10/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import Foundation
extension CGFloat{
    //段高度
    static let field0: CGFloat = 8 + 21 + 8 + 21 + 8            //短文本       66
    static let field1: CGFloat = 8 + 21 + 8 + 21 + 8            //长文本       66
    static let field2: CGFloat = 8 + 21 + 8 + 88 + 8            //图片        133
    static let field3: CGFloat = 8 + 21 + 8 + 21 + 8            //附件        66
    static let field4: CGFloat = 8 + 21 + 8 + 21 + 8            //单选        66
    static let field5: CGFloat = 8 + 21 + 8 + 21 + 8            //联动        66
    static let field6: CGFloat = 8 + 21 + 8 + 21 + 8            //多选        66
    static let field7: CGFloat = 8 + 21 + 8 + 21 + 8            //时间        66
    
    //组高度
    static let group0: CGFloat = 8 + 21 + 8 + 21 + 8 + 30 + 8            //普通组less   104
    static let group1: CGFloat = 8 + 21 + 8 + 21 + 8 + 30 + 8 + 30 + 8   //时间组       142
    static let group2: CGFloat = 8 + 21 + 8 + 30 + 8 + 30 + 8   //多条组less   113
    static let group3: CGFloat = 8 + 21 + 8 + 21 + 8 + 96 + 8   //图片组       162
}
