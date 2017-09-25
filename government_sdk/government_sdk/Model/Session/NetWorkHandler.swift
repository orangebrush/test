//
//  NetWorkRequest.swift
//  NetWorkSDK
//
//  Created by X Young. on 2017/9/21.
//  Copyright © 2017年 XinRui. All rights reserved.
//

import Foundation

public class NetWorkHandler {
    
    
    //MARK: 获取政策新闻
    /*
     *  @param page             //页数
     *  @Param pageSize         //每页记录数
     */
    public class func getPageNews(withParam param: NewsPageParams, _ closure: @escaping ((ResultCode, String, NewsPageModel?)->())){
        
        //请求参数
        let dict = [
            "page": param.page,
            "pageSize": param.pageSize
        ]
        
        //请求
        Session.session(withAction: .pageNews, withMethod: .POST, withParam: dict){
            resultCode, message, data in
            
            //判断数据是否为空
            guard let d = data else {
                closure(resultCode, message, nil)
                return
            }
            
            let newsPageModel = NewsPageModel()
            if let page = d["page"] as? Int{
                newsPageModel.page = page
            }
            if let totalCount = d["totalCount"] as? Int{
                newsPageModel.totalCount = totalCount
            }
            if let totalPage = d["totalPage"] as? Int{
                newsPageModel.totalPage = totalPage
            }
            
            //获取新闻列表
            if let newsdataList = d["results"] as? [[String: Any]]{
                
                var list = [NewsModel]()
                for newsdata in newsdataList{
                    let newsModel = NewsModel()
                    //获取ID
                    newsModel.id = newsdata["id"] as? Int
                    
                    //获取内容转换为URL
                    if let contentUrlStr = newsdata["url"] as? String{
                        let url = URL(string: contentUrlStr)
                        newsModel.contentUrl = url
                    }
                    
                    //***可能有问题
                    if let contentDate = newsdata["update"] as? Date{
                        newsModel.lastDate = contentDate
                    }
                    
                    //获取图片转换为URL
                    if let picUrlStr = newsdata["pic"] as? String{
                        let url = URL(string: picUrlStr)
                        newsModel.picUrl = url
                    }
                    
                    //获取政策新闻摘要
                    newsModel.summary = newsdata["summary"] as? String
                    
                    //获取标题
                    newsModel.title = newsdata["title"] as? String
                    
                    list.append(newsModel)
                }
                newsPageModel.newsModelList = list
            }
            closure(resultCode, message, newsPageModel)
        }
    }
}
    
    
    
    

