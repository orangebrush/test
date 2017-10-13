//
//  H+Attachment.swift
//  gov_sdk
//
//  Created by YiGan on 13/10/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import Foundation

public class Markdown: NSObject{    //附加链接
    public var id = 0
    public var title: String?                   //标题
    public var url: URL?
}
public class Attachment: NSObject{  //附件
    public var id = 0
    public var title: String?                   //标题
    public var url: URL?
}
public class Stuff: NSObject{       //线下材料对象
    public var id = 0
    public var title: String?                   //材料描述
    public var original: String?                //上交原件 验原件 无需原件
    public var copyTitle: String?               //复印件使用模式： 无需复印件 6份，加盖公章
    public var detailTitle: String?             //备注信息
    public var checked = false                  //是否已完成
    public var markdownList = [Markdown]()      //附加链接列表
    public var attachmentList = [Attachment]()  //附件列表
}


public class NWHAttachment: NSObject {
    
    //MARK:- init ------------------------------------------------------------
    private static let __once = NWHAttachment()
    public class func share() -> NWHAttachment{
        return __once
    }
    
    //MARK: 获取线下材料清单
    public func getAllStuff(withApplyId applyId: Int, withDidFinished didFinished: Bool, closure: @escaping (_ resultCode: ResultCode, _ message: String, _ data: [Stuff]?) -> ()){
        guard let account = localAccount, let password = localPassword else {
            closure(.failure, "未登录", nil)
            return
        }
        let dic: [String: Any] = [
            "applyId": applyId,
            "type": didFinished ? "C" : "U",
            "userId": account,
            "password": password
        ]
        
        Session.session(withAction: Actions.allStuff, withMethod: Method.get, withParam: dic) { (resultCode, message, data) in
            var stuffList = [Stuff]()
            if let stuffListData = data as? [[String: Any]]{
                for stuffData in stuffListData{
                    let stuff = Stuff()
                    if let id = stuffData["id"] as? Int{
                        stuff.id = id
                    }
                    stuff.title = stuffData["title"] as? String
                    stuff.original = stuffData["original"] as? String
                    stuff.copyTitle = stuffData["copy"] as? String
                    stuff.detailTitle = stuffData["description"] as? String
                    if let checked = stuffData["checked"] as? Bool{
                        stuff.checked = checked
                    }
                    if let markdownListData = stuffData["markdowns"] as? [[String: Any]]{
                        for markdownData in markdownListData{
                            let markdown = Markdown()
                            if let id = markdownData["id"] as? Int{
                                markdown.id = id
                            }
                            markdown.title = markdownData["title"] as? String
                            if let urlString = markdownData["url"] as? String{
                                markdown.url = URL(string: urlString)
                            }
                            stuff.markdownList.append(markdown)
                        }
                    }
                    if let attachmentListData = stuffData["attachments"] as? [[String: Any]]{
                        for attachmentData in attachmentListData{
                            let attachment = Attachment()
                            if let id = attachmentData["id"] as? Int{
                                attachment.id = id
                            }
                            attachment.title = attachmentData["title"] as? String
                            if let urlString = attachmentData["url"] as? String{
                                attachment.url = URL(string: urlString)
                            }
                            stuff.attachmentList.append(attachment)
                        }
                    }
                    stuffList.append(stuff)
                }
            }
            closure(resultCode, message, stuffList)
        }
    }
    
    //MARK: 标记线下材料完成情况
    public func markStuff(withApplyId applyId: Int, withStuffId stuffId: Int, withMarked marked: Bool, closure: @escaping (_ resultCode: ResultCode, _ message: String, _ data: Any?) -> ()){
        guard let account = localAccount, let password = localPassword else {
            closure(.failure, "未登录", nil)
            return
        }
        let dic: [String: Any] = [
            "applyId": applyId,
            "attachmentId": stuffId,
            "checked": marked,
            "userId": account,
            "password": password
        ]
        Session.session(withAction: Actions.markStuff, withMethod: Method.post, withParam: dic, closure: closure)
    }
}
