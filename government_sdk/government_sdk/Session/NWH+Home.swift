//
//  NWHHome.swift
//  government_sdk
//
//  Created by YiGan on 12/10/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import Foundation

public class NWHNewsParams: NSObject{
    public var page = 1
    public var pageSize = 8
}

public class NWHNews: NSObject{
    public var id = 0
    public var title: String?
    public var picUrl: URL?
    public var summary: String?
    public var url: URL?
    public var lastDate = Date()
}

public class NWHNewsData: NSObject{
    public var totalCount: Int = 0
    public var page: Int = 0
    public var totalPage: Int = 0
    public var newsList = [NWHNews]()
}

public class NWHHome: NSObject {
    
    //MARK:- init ------------------------------------------------------------
    private static let __once = NWHHome()
    public class func share() -> NWHHome{
        return __once
    }
    
    ///获取所有政策新闻
    public func getAllNews(withParams params: NWHNewsParams, closure: @escaping (_ resultCode: ResultCode, _ message: String, _ data: NWHNewsData?) -> ()) {
        let dict = [
            "page": params.page,
            "pageSize": params.pageSize
        ]
        Session.session(withAction: NWHActions.allNews, withMethod: NWHMethod.get, withParam: dict, closure: {
            resultCode, message, data in
            guard let d = data as? [String: Any] else{
                closure(.failure, message, nil)
                return
            }
            
            let newsData = NWHNewsData()
            
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
                    let news = NWHNews()
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
                    if let update = result["update"] as? Int{
                        
                    }
                    newsData.newsList.append(news)
                }
            }
            
            closure(resultCode, message, newsData)
        })
    }
}
