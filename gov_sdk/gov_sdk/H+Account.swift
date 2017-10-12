//
//  H+Account.swift
//  gov_sdk
//
//  Created by YiGan on 12/10/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import Foundation
public class NWHAccount: NSObject {
    
    //MARK:- init ------------------------------------------------------------
    private static let __once = NWHAccount()
    public class func share() -> NWHAccount{
        return __once
    }
}
