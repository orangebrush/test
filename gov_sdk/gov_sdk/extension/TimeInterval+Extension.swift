//
//  Int+Extension.swift
//  gov_sdk
//
//  Created by YiGan on 12/10/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import Foundation
extension TimeInterval{
    
    func date() -> Date{
        return Date(timeIntervalSince1970: self)
    }
}
