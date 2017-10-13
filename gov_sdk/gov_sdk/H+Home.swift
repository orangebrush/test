//
//  H+Home.swift
//  gov_sdk
//
//  Created by YiGan on 12/10/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import Foundation

//新闻相关
public class AllNewsParams: NSObject{
    public var page = 1                         //页码
    public var pageSize = 8                     //每页记录数
}
public class News: NSObject{
    public var id = 0
    public var title: String?
    public var picUrl: URL?                     //图片链接
    public var summary: String?
    public var url: URL?                        //文章markdown链接
    public var date = Date()                //最后更新时间
}
public class AllNewsData: NSObject{
    public var totalCount: Int = 0
    public var page: Int = 0
    public var totalPage: Int = 0
    public var newsList = [News]()
}

//政策相关
public class AllPolicyParams: NSObject{
    public var page = 1                         //页码
    public var pageSize = 10                    //每页记录数
}
public class Applicant: NSObject{               //扶持对象
    public var id = 0
    public var name: String?                    //扶持对象名称
    public var detailText: String?              //扶持对象描述
}
public enum DocumentFieldType: String{          //政策段落类型
    case chapter    = "C"                //章
    case item       = "S"                //条
    case paragraph  = "P"                //段
}
public class Document: NSObject{                //政策文件
    public var id = 0
    public var title: String?
    public var type: DocumentFieldType?
}
public class Prize: NSObject{                   //资助
    public var id = 0                       //资助id
    public var title: String?               //资助标题
    public var paragraphId = 0              //章或条id
}
public class Policy: NSObject{
    public var id = 0
    public var shortTitle: String?              //短标题
    public var longTitle: String?               //长标题
    public var smallPicUrl: URL?                //缩略图
    public var bigPicUrl: URL?                  //大图
    public var summary: String?                 //引言
    public var date: Date?                      //发布日期
    public var endDate: Date?                   //截止日期
    public var applicantList = [Applicant]()    //扶持对象
    public var documentList = [Document]()      //政策文件
    public var prizeList = [Prize]()            //资助
}
public class AllPolicyData: NSObject{
    public var totalCount: Int = 0
    public var page = 0
    public var totalPage = 0
    public var policyList = [Policy]()
}

public class NWHHome: NSObject {
    
    //MARK:- init ------------------------------------------------------------
    private static let __once = NWHHome()
    public class func share() -> NWHHome{
        return __once
    }
    
    ///获取所有政策新闻
    public func getAllNews(withParams params: AllNewsParams = AllNewsParams(), closure: @escaping (_ resultCode: ResultCode, _ message: String, _ data: AllNewsData?) -> ()) {
        let dict = [
            "page": "\(params.page)",
            "pageSize": "\(params.pageSize)"
        ]
        Session.session(withAction: Actions.allNews, withMethod: Method.get, withParam: dict, closure: {
            resultCode, message, data in
            
            let newsData = AllNewsData()
            
            if let d = data as? [String: Any]{
                if let totalCount = d["totalCount"] as? Int{
                    newsData.totalCount = totalCount
                }
                if let page = d["page"] as? Int{
                    newsData.page = page
                }
                if let totalPage = d["totalPage"] as? Int{
                    newsData.totalPage = totalPage
                }
                if let results = d["results"] as? [[String: Any]]{
                    for result in results {
                        let news = News()
                        if let id = result["id"] as? Int{
                            news.id = id
                        }
                        news.title = result["title"] as? String
                        if let picStr = result["pic"] as? String{
                            news.picUrl = URL(string: picStr)
                        }
                        news.summary = result["summary"] as? String
                        if let urlStr = result["url"] as? String{
                            news.url = URL(string: urlStr)
                        }
                        if let update = result["update"] as? TimeInterval{
                            news.date = update.date()
                        }
                        newsData.newsList.append(news)
                    }
                }
            }
            
            closure(resultCode, message, newsData)
        })
    }
    
    //获取所有政策
    public func getAllPolicy(withParams params: AllPolicyParams = AllPolicyParams(), closure: @escaping (_ resultCode: ResultCode, _ message: String, _ data: AllPolicyData?) -> ()){
        let dict = [
            "page": "\(params.page)",
            "pageSize": "\(params.pageSize)"
        ]
        Session.session(withAction: Actions.allPolicy , withMethod: Method.get, withParam: dict) { (resultCode, message, data) in
            let allPolicyData = AllPolicyData()
            
            if let d = data as? [String: Any]{
                if let totalCount = d["totalCount"] as? Int{
                    allPolicyData.totalCount = totalCount
                }
                if let page = d["page"] as? Int{
                    allPolicyData.page = page
                }
                if let totalPage = d["totalPage"] as? Int{
                    allPolicyData.totalPage = totalPage
                }
                if let results = d["results"] as? [[String: Any]]{
                    for result in results{
                        let policy = DataEncode.policy(withPolicyData: result)
                        allPolicyData.policyList.append(policy)
                    }
                }
            }
            
            closure(resultCode, message, allPolicyData)
        }
    }
}
