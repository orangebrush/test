//
//  Time.swift
//  government_sdk
//
//  Created by X Young. on 2017/9/25.
//  Copyright © 2017年 YiGan. All rights reserved.
//

import Foundation
public extension Int {
    
    var currentTimeInterval : TimeInterval {
        return NSDate().timeIntervalSince1970
    }
    
    //MARK: 根据规则返回对应的字符串
    public func getTimeString() -> String {
        if isToday {
            if minute < 5 {
                return "刚刚"
            } else if hour < 1 {
                return "\(minute)分钟之前"
            } else {
                return "\(hour)小时之前"
            }
        } else if isYesterday {
            return "昨天 \(self.yesterdayTimeStr())"
        } else if isYear {
            return noYesterdayTimeStr()
        } else {
            return yearTimeStr()
        }
    }
    
    fileprivate var selfDate : Date {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
    
    /// 距当前有几分钟
    var minute : Int {
        let dateComponent = Calendar.current.dateComponents([.minute], from: selfDate, to: Date())
        return dateComponent.minute!
    }
    
    /// 距当前有几小时
    var hour : Int {
        let dateComponent = Calendar.current.dateComponents([.hour], from: selfDate, to: Date())
        return dateComponent.hour!
    }
    
    /// 是否是今天
    var isToday : Bool {
        return Calendar.current.isDateInToday(selfDate)
    }
    
    /// 是否是昨天
    var isYesterday : Bool {
        return Calendar.current.isDateInYesterday(selfDate)
    }
    
    /// 是否是今年
    var isYear: Bool {
        let nowComponent = Calendar.current.dateComponents([.year], from: Date())
        let component = Calendar.current.dateComponents([.year], from: selfDate)
        return (nowComponent.year == component.year)
    }
    
    func yesterdayTimeStr() -> String {
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        return format.string(from: selfDate)
    }
    
    func noYesterdayTimeStr() -> String {
        let format = DateFormatter()
        format.dateFormat = "MM-dd HH:mm"
        return format.string(from: selfDate)
    }
    
    func yearTimeStr() -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm"
        return format.string(from: selfDate)
    }
    
    //MARK: 自定义的方法
    
    /// 变量时间转 X天前/X天后
    ///
    /// - Parameter isNeedSuffix: 是否需要后缀(前/后)
    /// - Returns: 天数字符串
    func timeIntervalToString(isNeedSuffix:Bool) -> String {
        
        if (self - Int(currentTimeInterval)) < 0{
            
            let day:Int = (Int(currentTimeInterval) - self) / (60 * 60 * 24)
            if isNeedSuffix == false{
                
                return String(day) + "天"
            }else{
                
                return String(day) + "天前"
            }
            
        }else{
            
            let day:Int = (self - Int(currentTimeInterval)) / (60 * 60 * 24)
            if isNeedSuffix == false{
                
                return String(day) + "天"
            }else{
                
                return String(day) + "天后"
            }
        }
        
    }
    
    /// 比对变量时间与当前时间
    ///
    /// - Returns: true(变量时间大于当前时间)
    func contrastTimeIntervalAndNow() -> Bool {
        if (self - Int(currentTimeInterval)) > 0{
            return true
        }else{
            return false
        }
        
    }
    
}
