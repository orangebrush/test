//
//  NetWorkRequest.swift
//  NetWorkSDK
//
//  Created by X Young. on 2017/9/21.
//  Copyright © 2017年 XinRui. All rights reserved.
//

import Foundation
import HandyJSON

//MARK: 1.请求
public class Handler {
    
    
    //MARK: 1.0 获取政策新闻
    /*
     *  @param page             //页数
     *  @Param pageSize         //每页记录数
     */
    public class func getPageNews(withParam param: NewsPageParams, _ closure: @escaping ((ResultCode, String, NewsPageModel?)->())){
        
        //请求参数
        let dict = [
            "page": param.page!,
            "pageSize": param.pageSize!
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
    
    //MARK: 1.1 获取用户申请列表
    public class func getPageNews( _ closure: @escaping ((ResultCode, String, ApplyListModel?)->())){
        
        Session.session(withAction: .myApplyList, withMethod: .GET, withParam:Optional.none!) { (resultCode, message, data) in
            
            //判断数据是否为空
            guard let d = data else {
                closure(resultCode, message, nil)
                return
            }
            
            var applySecondList:Array<ApplyListModel> = []
            
            let jsonArrayString: String? = getJSONStringFromDictionary(dictionary: d as NSDictionary)
            if let applyVirginList = [ApplyListVirginModel].deserialize(from: jsonArrayString) {
                applyVirginList.forEach({(ApplyListVirginModel) in
                    
                    let applyListSecondModel = ApplyListModel()
                    applyListSecondModel.id = ApplyListVirginModel?.id
                    // 映射申请状态
                    if ApplyListVirginModel?.applyStatus == ApplyStatus.ApplyStatus_1_New || ApplyListVirginModel?.applyStatus == ApplyStatus.ApplyStatus_1_FillIning || ApplyListVirginModel?.applyStatus == ApplyStatus.ApplyStatus_1_Pending{
                        
                        applyListSecondModel.applyStatus = "填写中"
                        
                    }else if ApplyListVirginModel?.applyStatus == ApplyStatus.ApplyStatus_2_UnRead || ApplyListVirginModel?.applyStatus == ApplyStatus.ApplyStatus_2_NotProcessed || ApplyListVirginModel?.applyStatus == ApplyStatus.ApplyStatus_2_NoConsider || ApplyListVirginModel?.applyStatus == ApplyStatus.ApplyStatus_2_Reject{
                        
                        applyListSecondModel.applyStatus = "审核中"
                        
                    }else if ApplyListVirginModel?.applyStatus == ApplyStatus.ApplyStatus_3_NoAppointDate || ApplyListVirginModel?.applyStatus == ApplyStatus.ApplyStatus_3_HandleAppointDate || ApplyListVirginModel?.applyStatus == ApplyStatus.ApplyStatus_3_ApprovedAppropriation || ApplyListVirginModel?.applyStatus == ApplyStatus.ApplyStatus_3_RefusalAppropriation{
                        
                        applyListSecondModel.applyStatus = "已进入线下办理"
                        
                        // 存在已经预约的情况
                        if ((ApplyListVirginModel?.appointment?.appointDate) != nil){
                            
                            // 未到预约时间
                            if contrastTimeIntervalAndNow(backTimeInterval: (ApplyListVirginModel?.appointment?.appointDate)!){
                                let appointDateString = ApplyListVirginModel?.appointment?.appointDate?.yearTimeStr()
                                applyListSecondModel.statusDescribtion = "距离前往政府办理还有\(timeIntervalToString(backTimeInterval: (ApplyListVirginModel?.appointment?.appointDate)!, isNeedSuffix: false))" + "具体时间:" + "\(String(describing: appointDateString))"
                            
                            // 已经到了到预约时间
                            }else{
                                
                                applyListSecondModel.statusDescribtion = "预约时间已过,结果如何?"
                                
                            }
                            
                            
                        // 还没预约的情况
                        }else{
                            
                            applyListSecondModel.statusDescribtion = "恭喜你已经通过了线上审核,请预约办理时间"
                        }
                        
                    }else if ApplyListVirginModel?.applyStatus == ApplyStatus.ApplyStatus_4_Expired || ApplyListVirginModel?.applyStatus == ApplyStatus.ApplyStatus_4_OffShelf || ApplyListVirginModel?.applyStatus == ApplyStatus.ApplyStatus_4_Blacklist || ApplyListVirginModel?.applyStatus == ApplyStatus.ApplyStatus_4_Interrupt{
                        
                        applyListSecondModel.applyStatus = "已完结的申请"
                        
                    }
                    applyListSecondModel.title = ApplyListVirginModel?.policyShortTitle
                    
                    applyListSecondModel.lastUpdateAt = timeIntervalToString(backTimeInterval: (ApplyListVirginModel?.lastUpdateAt)!, isNeedSuffix: true)
                    
                    applySecondList.append(applyListSecondModel)
  
                })
            }
            
        }
        
        
        
    }
    
    
}


//MARK: 2. 一些需处理的返回数据模型

//MARK: 2.1 我的申请列表处女数据
class ApplyListVirginModel: HandyJSON {

    var id:Int!                             // 申请实例ID
    var policyId:Int!                       // 政策ID
    var policyShortTitle:String!            // 政策短标题
    var createAt:Int!                      // 申请实例创建时间
    var applyAt:Int?                       // 申请提交时间
    var applyStatus:ApplyStatus!            // 申请状态
    var lastUpdateAt:Int?                  // 申请状态最后更新时间
    var dateHint:String?                    // 时间跨度描述信息
    var statusHint:String?                  // 状态描述信息
    var appointment:Appointment?            // 预约线下办理信息
    var reason:String?                      // 驳回/中断理由
    var instanceStatus:ApplyInstanceStatus? // 申请实例状态
    var cancelAt:Int?                      // 取消/移除时间（对应申请实例状态）
    var finished:Int?                       // 资料完成度（填写申请中） 或 准备材料完成度（线下办理中）
    
    required init() {}
}
//MARK: 2.1.1 预约线下办理信息Appointment
class Appointment: HandyJSON {
    
    var address: String?
    var appointDate: Int?
    var governmentContact: GovernmentContact?
    var memo: String?
    
    required init() {}
}
//MARK: 2.1.2 政府联系人
class GovernmentContact: HandyJSON {
    
    var name: String? // 姓名
    var phone: String? // 联系电话
    
    required init() {}
}

//MARK: 3. 一些有用的方法

//MARK: 3.1 字典转JSONString
func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
    if (!JSONSerialization.isValidJSONObject(dictionary)) {
        print("无法解析出JSONString")
        return ""
    }
    let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData!
    let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
    return JSONString! as String
    
}

//MARK: 3.2 时间戳转 X天前/X天后
func timeIntervalToString(backTimeInterval:Int, isNeedSuffix:Bool) -> String {
    
    let nowTimeInterval = Int(NSDate().timeIntervalSince1970 * 1000)
    
    if (backTimeInterval - nowTimeInterval) < 0{
        
        let day:Int = Int((nowTimeInterval - backTimeInterval) / (60 * 60 * 24))
        if isNeedSuffix == false{
            
            return String(day) + "天"
        }else{
            
            return String(day) + "天前"
        }
        
    }else{
       
        let day:Int = Int((backTimeInterval - nowTimeInterval) / (60 * 60 * 24))
        if isNeedSuffix == false{
            
            return String(day) + "天"
        }else{
            
            return String(day) + "天后"
        }
    }
    
}

//MARK: 3.3 比对传进来的时间与当前时间
/// - Returns: true(后台时间大于当前时间)
func contrastTimeIntervalAndNow(backTimeInterval:Int) -> Bool {
    let nowTimeInterval = Int(NSDate().timeIntervalSince1970 * 1000)
    if (backTimeInterval - nowTimeInterval) > 0{
        return true
    }else{
        return false
    }
    
}

