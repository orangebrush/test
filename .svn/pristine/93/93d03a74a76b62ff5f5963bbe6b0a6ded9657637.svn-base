//
//  NewsModel.swift
//  NetWorkSDK
//
//  Created by X Young. on 2017/9/22.
//  Copyright © 2017年 XinRui. All rights reserved.
//

import Foundation

//MARK: 1.获取政策新闻

//请求参数
public class NewsPageParams: NSObject{
    public var page: Int?
    public var pageSize: Int?
    public override init() {
        super.init()
    }
}

//返回数据
public class NewsPageModel: NSObject {
    public var totalCount: Int?
    public var page: Int?
    public var totalPage: Int?
    public var newsModelList: [NewsModel]?
}

//新闻内容
public class NewsModel: NSObject {
    public var id: Int?
    public var title: String?
    public var picUrl: URL?
    public var summary: String?
    public var contentUrl: URL?
    public var lastDate: Date?
}



