//
//  PolicyModel.swift
//  government_sdk
//
//  Created by X Young. on 2017/9/25.
//  Copyright © 2017年 YiGan. All rights reserved.
//

import Foundation
import HandyJSON


//public class HomepagePolicyListModel: HandyJSON{
//
//    /// 政策ID
//    public var id:Int?
//
//    /// 政策短标题
//    public var shortTitle:String?
//
//    /// 政策图片URL(首页缩略图)
//    public var smallPic:String?
//
//    /// 扶持对象
//    public var applyTo:[BookmarkPolicyApplyTo]!
//
//    required public init() {}
//}

//MARK: 1.0 首页政策模型
public class HomepagePolicyModel: HandyJSON {
    
    /// 政策ID
    public var id:Int?
    
    /// 政策短标题
    public var shortTitle:String?
    
    /// 政策图片URL(首页缩略图)
    public var smallPic:String?
    
    /// 扶持对象
    public var applyTo:[BookmarkPolicyApplyTo]! = [BookmarkPolicyApplyTo]()
    
    required public init() {}
}

//MARK: 2.0 详细政策模型

//请求参数
public class PolicyId: NSObject{
    
    public var id: Int?
    
    public override init() {
        super.init()
    }
}

public class DetailPolicyModel: HandyJSON{

    // 政策ID
    public var id:Int?

    // 政策短标题
    public var shortTitle:String?

    // 政策长标题
    public var longTitle:String?

    // 政策图片URL(高清大图)
    public var bigPic:String?

    // 政策引言
    public var summary:String?

    // 扶持对象
    public var applyTo:[BookmarkPolicyApplyTo]? = [BookmarkPolicyApplyTo]()
    
    // 政策文件
    public var document:[PolicyDocumentModel]? = [PolicyDocumentModel]()
    
    // 资助
    public var prizes:[PolicyPrizes]? = [PolicyPrizes]()
    
    // 是否可以标注书签
    public var canBookmark:Bool?
    
    required public init() {}
}
//MARK: 2.1 政策文件模型
public class PolicyDocumentModel: HandyJSON{
    
    /// 政策文件ID
    public var id:Int?
    
    /// 政策文件标题
    public var title:String?
    
    /// 段落类型：章(C)、条(S)、段(P)
    public var type:String?
    
    /// 段落属性：正文(B)、要求(C)、折叠(H)
    public var contentType:String?
    
    required public init() {}
}
//MARK: 2.2 政策资助模型
public class PolicyPrizes: HandyJSON{
    
    /// 政策资助ID
    public var id:Int?
    
    /// 政策资助标题
    public var title:String?
    
    /// 所在段ID（也可以是章ID和条ID，章和条属于特殊的段）
    public var paragraphId:Int?
    
    required public init() {}
}

/*

 
 */
