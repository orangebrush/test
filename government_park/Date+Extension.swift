//
//  Date+Extension.swift
//  government_park
//
//  Created by YiGan on 16/10/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import Foundation
extension Date{
    func hint() -> String{
        
        let dateComponents = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: Date(), to: self)
        let year = dateComponents.year ?? 0
        let month = dateComponents.month ?? 0
        let day = dateComponents.day ?? 0
        let hour = dateComponents.hour ?? 0
        let minute = dateComponents.minute ?? 0
        
        let result: String
        if year > 0 {
            result = "\(year)年前"
        }else if month > 0{
            result = "\(month)月前"
        }else if day > 0{
            result = "\(day)天前"
        }else if hour > 0{
            result = "\(hour)小时前"
        }else {
            result = "\(minute)分钟前"
        }
        
        return result
    }
}
