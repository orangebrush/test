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

let accountLength = 11
let passwordMaxLength = 20
let passwordMinLength = 6

//MARK:- 正则表达式
struct Regex {
    let regex: NSRegularExpression?
    
    init(_ pattern: String) {
        regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    func match(input: String) -> Bool {
        if let matches = regex?.matches(in: input, options: [], range: NSMakeRange(0, (input as NSString).length)) {
            return matches.count > 0
        }
        return false
    }
}

//判断密码是否合法
func isPasswordLegal(withString string: String?) -> (isLegal: Bool, message: String) {
    //判断密码是否为空
    guard let password: String = string, !password.characters.isEmpty else{
        return (false, "密码不能为空")
    }
    
    let count = password.characters.count
    guard  count >= passwordMinLength, count <= passwordMaxLength  else {
        return (false, "密码长度为\(passwordMinLength)~\(passwordMaxLength)之间")
    }
    return (true, "")
}

//判断账号是否合法
func isAccountLegal(withString string: String?) -> (isLegal: Bool, message: String) {
    //判断账号是否为空
    guard let account: String = string, !account.characters.isEmpty else {
        return (false, "账号不能为空")
    }
    
    //判断账号是否合法
    let mailPattern = "^1[0-9]{10}$"
    let matcher = Regex(mailPattern)
    guard matcher.match(input: account) else{
        return (false, "账号需为合法的手机号")
    }
    
    return (true, "")
}
