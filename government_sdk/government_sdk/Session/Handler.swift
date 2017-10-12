//
//  NetWorkRequest.swift
//  NetWorkSDK
//
//  Created by X Young. on 2017/9/21.
//  Copyright © 2017年 XinRui. All rights reserved.
//

import Foundation
import UIKit
import HandyJSON

//MARK: 1.请求
public class Handler {
    
    //MARK: 1.0 获取政策新闻
    /*
     *  @param page             //页数
     *  @Param pageSize         //每页记录数
     */
    public class func getPageNews( _ closure: @escaping ((ResultCode, String, NewsPageModel?)->())){
        
        
        //请求
        Session.session(withStringAction: "/news", withMethod: .GET, withParam: nil) { (resultCode, message, data) in
            
            //判断数据是否为空
            guard let d = data else {
                closure(resultCode, message, nil)
                return
            }
            let dict = d as! [String: Any]

            /*
             from: d as! Dictionary
             */
            let newsPageModel = NewsPageModel()
            if let page = dict["page"] as? Int{
                newsPageModel.page = page
            }
            if let totalCount = dict["totalCount"] as? Int{
                newsPageModel.totalCount = totalCount
            }
            if let totalPage = dict["totalPage"] as? Int{
                newsPageModel.totalPage = totalPage
            }

            //获取新闻列表
            if let newsdataList = dict["results"] as? [[String: Any]]{

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
    /// (我)获取用户申请列表
    public class func getUserApply(withLoginName loginName:String?, withPassword password:String?, _ closure: @escaping ((ResultCode, String, [ApplyVirginModel]?)->())){
        
        // 拼接地址
        let urlString = "/apply"
        
        Session.session(withStringAction: urlString, withMethod: .GET, withParam: nil, withLoginName: loginName, withPassword: password) { (resultCode, message, data) in
            
            //判断数据是否为空
            guard let d = data else {
                closure(resultCode, message, nil)
                return
            }
            
            var applyFinalList = [ApplyVirginModel]()
            
            // 获取申请
            if let applyFirstList = [ApplyVirginModel].deserialize(from: d as! Array){
                applyFirstList.forEach({ (applyVirginModel) in
                    
                    // 映射申请状态
                    if applyVirginModel?.applyStatus == DetailApplyStatus.ApplyStatus_1_New || applyVirginModel?.applyStatus == DetailApplyStatus.ApplyStatus_1_FillIning || applyVirginModel?.applyStatus == DetailApplyStatus.ApplyStatus_1_Pending{
                        
                        applyVirginModel?.kindApplyStatus = KindApplyStatus.Writing
                        
                        
                    }else if applyVirginModel?.applyStatus == DetailApplyStatus.ApplyStatus_2_UnRead || applyVirginModel?.applyStatus == DetailApplyStatus.ApplyStatus_2_NotProcessed || applyVirginModel?.applyStatus == DetailApplyStatus.ApplyStatus_2_NoConsider || applyVirginModel?.applyStatus == DetailApplyStatus.ApplyStatus_2_Reject{
                        
                        applyVirginModel?.kindApplyStatus = KindApplyStatus.Reading
                        
                        
                    }else if applyVirginModel?.applyStatus == DetailApplyStatus.ApplyStatus_3_NoAppointDate || applyVirginModel?.applyStatus == DetailApplyStatus.ApplyStatus_3_HandleAppointDate || applyVirginModel?.applyStatus == DetailApplyStatus.ApplyStatus_3_ApprovedAppropriation || applyVirginModel?.applyStatus == DetailApplyStatus.ApplyStatus_3_RefusalAppropriation{
                        
                        applyVirginModel?.kindApplyStatus = KindApplyStatus.BlowLine
                        
                        
                    }else if applyVirginModel?.applyStatus == DetailApplyStatus.ApplyStatus_4_Expired || applyVirginModel?.applyStatus == DetailApplyStatus.ApplyStatus_4_OffShelf || applyVirginModel?.applyStatus == DetailApplyStatus.ApplyStatus_4_Blacklist || applyVirginModel?.applyStatus == DetailApplyStatus.ApplyStatus_4_Interrupt{
                        
                        applyVirginModel?.kindApplyStatus = KindApplyStatus.End
                        
                    }
                    
                    applyFinalList.append(applyVirginModel!)
                    
                })
            
            }
            
            Session.session(withStringAction: "/policy/bookmark", withMethod: .GET, withParam: nil, withLoginName: loginName, withPassword: password) { (resultCode, message, data) in
                
                guard let d = data else {
                    closure(resultCode, message, nil)
                    return
                }
                
                if let bookmarkPolicyList = [BookmarkPolicyVirginModel].deserialize(from: d as! Array) {
                    bookmarkPolicyList.forEach({(BookmarkPolicyVirginModel) in
                        
                        let applyCollectModel = ApplyVirginModel()
                        
                        applyCollectModel.id = BookmarkPolicyVirginModel?.id
                        applyCollectModel.policyShortTitle = BookmarkPolicyVirginModel?.title
                        applyCollectModel.kindApplyStatus = KindApplyStatus.Collect
                        applyCollectModel.dateHint = BookmarkPolicyVirginModel?.dateHint
                        
                        let firstOne:BookmarkPolicyApplyTo = (BookmarkPolicyVirginModel?.applyTo[0])!
                        if ((BookmarkPolicyVirginModel?.applyTo.count)! - 1 ) > 0{
                            applyCollectModel.statusHint = "扶持对象:" + "\(String(describing: firstOne.target))" + "等" + "\((BookmarkPolicyVirginModel?.applyTo.count)! - 1)" + "个"
                            
                        }else{
                            applyCollectModel.statusHint = "扶持对象:" + "\(String(describing: firstOne.target))"
                        }
                        
                        applyFinalList.append(applyCollectModel)
                    })
                    
                }
                
                
            }
            closure(resultCode, message, applyFinalList)
        }
    }
    //MARK: 1.2 获取首页政策
    /// (首页)获取首页政策
    public class func getAllHomepagePolicy(_ closure: @escaping ((ResultCode, String, [HomepagePolicyModel]?)->())){
        //请求
        Session.session(withStringAction: "/policy", withMethod: .GET, withParam: nil) { (resultCode, message, data) in
            
            guard let d = data else {
                closure(resultCode, message, nil)
                return
            }
            
            var homepagePolicyList:[HomepagePolicyModel]
            
            let list: [Any] = (d as! [String: Any])["results"] as! [Any]
            
            homepagePolicyList = [HomepagePolicyModel].deserialize(from: list)! as! [HomepagePolicyModel]
            
            homepagePolicyList.forEach({ (homepagePolicyModel) in
                
                if homepagePolicyModel.applyTo == nil{
                    
                    homepagePolicyModel.applyTo = []
                }
                
            })
            
            
            closure(resultCode, message, homepagePolicyList)
        }
        
        
    }
    
    //MARK: 1.3 获取政策详情
    /// (首页)获取政策详情
    public class func getDetailPolicy(withPolicyId id: Int ,_ closure: @escaping ((ResultCode, String, DetailPolicyModel?)->())){
        
        let urlStr = "/policy/" + "\(id)"
        
        Session.session(withStringAction: urlStr, withMethod: .GET, withParam: nil) { (resultCode, message, data)  in
            
            guard let d = data else {
                closure(resultCode, message, nil)
                return
            }
            
            let detailPolicyModel:DetailPolicyModel = DetailPolicyModel.deserialize(from: d as! Dictionary)!
            if detailPolicyModel.applyTo == nil{
                
                detailPolicyModel.applyTo = []
            }
            closure(resultCode, message,detailPolicyModel)
        }
        
    }
    
    
    //MARK: 1.4 根据政策id获取申请对象
    /// (首页)根据政策id获取申请对象
    public class func getApplyContents(withPolicyId id: Int,withLoginName loginName:String?, withPassword password:String?,_ closure: @escaping ((ResultCode, String, ApplyInstance?)->())){
        
        // 拼接地址
//        let urlString = "/apply?policyId=" + "\(id)"
        let urlString = "/apply"
        
        let dict = ["policyId":id]
        
        
        
        //请求
        Session.session(withStringAction: urlString, withMethod: .POST, withParam:dict, withLoginName: loginName, withPassword: password) { (resultCode, message, data) in
            
            guard let d = data else {
                closure(resultCode, message, nil)
                return
            }
            
            let applyInstance:ApplyInstance = ApplyInstance.deserialize(from: d as! Dictionary)!
            
            closure(resultCode, message,applyInstance)
        }
        
        
    
    }
    
    //MARK: 1.5 根据申请id获取申请对象
    /// (首页)根据申请id获取申请对象
    public class func getApplyContents(withApplyId id: Int,withLoginName loginName:String?, withPassword password:String?,_ closure: @escaping ((ResultCode, String, ApplyInstance?)->())){
        
        // 拼接地址
        let urlString = "/apply/" + "\(String(id))"

        //请求
        Session.session(withStringAction: urlString, withMethod: .GET, withParam: nil, withLoginName: loginName, withPassword: password) { (resultCode, message, data) in
            
            guard let d = data else {
                closure(resultCode, message, nil)
                return
            }
            
            let applyInstance:ApplyInstance = ApplyInstance.deserialize(from: d as! Dictionary)!
            
            closure(resultCode, message,applyInstance)
        }
        
        
    }
    
    
     //MARK: 1.6 根据申请id提交申请
     /// (首页)根据申请id提交申请
     public class func submitApply(withApplyId id: Int,withLoginName loginName:String?, withPassword password:String?, _ closure: @escaping ((ResultCode, String)->())){
        
        // 拼接地址
        let urlString = "/apply/" + "\(String(id))" + "/submit"
        
        Session.session(withStringAction: urlString, withMethod: .POST, withParam: nil, withLoginName: loginName, withPassword: password) { (resultCode, message, data) in
            
            guard let d = data else {
                closure(resultCode, message)
                return
            }
            
            closure(resultCode, message)
        }
        
     }
    
    //MARK: 1.7 根据申请id取消申请
    /// (首页)根据申请id取消申请
    public class func cancelApply(withApplyId id: Int,withLoginName loginName:String?, withPassword password:String?, _ closure: @escaping ((ResultCode, String)->())){
        
        // 拼接地址
        let urlString = "/apply/" + "\(String(id))" + "/cancel"
        
        Session.session(withStringAction: urlString, withMethod: .POST, withParam: nil, withLoginName: loginName, withPassword: password) { (resultCode, message, data)  in
            
            guard let d = data else {
                closure(resultCode, message)
                return
            }
            
            closure(resultCode, message)
        }
        
        
        
    }
    
    
    //MARK: 1.8.9.10 获取组数据
    /// 获取组数据
    public class func geContents(withIdList idList:[Int?], withGroupTpye groupTpye:Int!, withItemInstanceId itemInstanceId: Int?, withLoginName loginName:String?, withPassword password:String?, _ closure: @escaping ((ResultCode, String, BaseGroupModel?)->())){
        
        var idNum = idList.count
        var urlString:String!
        
        if idNum == 2 {
            urlString = "/component/" + "\(idList[1])" + "/" + "\(idList[0])"
        }else if idNum == 3{
            
            // 普通组的情况
            if groupTpye == 0{
                
                // 获取普通组下的普通组
                if itemInstanceId == nil{
                
                    urlString = "/component/" + "\(String(describing: idList[1]))" + "/" + "\(String(describing: idList[0]))" + "/" + "\(String(describing: idList[3]))" + "?itemInstance="
                    
                // 获取普通组下的条目
                }else{
                    
                    urlString = "/component/" + "\(String(describing: idList[1]))" + "/" + "\(String(describing: idList[0]))" + "/" + "\(String(describing: idList[3]))" + "?itemInstance=" + "\(String(describing: itemInstanceId))"
                }
                
                
                
            
            // 获取其他组的条目
            }else{
                
                urlString = "/component/" + "\(String(describing: idList[1]))" + "/" + "\(String(describing: idList[0]))" + "/" + "\(String(describing: idList[3]))" + "?itemInstance=" + "\(String(describing: itemInstanceId))"
                
            }
            
        }
        
        
        Session.session(withStringAction: urlString, withMethod: .GET, withParam: nil, withLoginName: loginName, withPassword: password) { (resultCode, message, data) in
            
            guard let d = data else {
                closure(resultCode, message, nil)
                return
            }
            
//            let jsonArrayString: String? = getJSONStringFromDictionary(dictionary: d)
            var baseGroupModel = BaseGroupModel()
            
            if idNum == 2 {
                baseGroupModel = NormalGroupModel.deserialize(from: d as! Dictionary)!
                baseGroupModel.isRoot = true
                baseGroupModel.isGroup = true
                baseGroupModel.type = 0
                
            }else if idNum == 3{
                // 普通组的情况
                if groupTpye == 0{
                    // 获取普通组下的普通组
                    if itemInstanceId == nil{
                        
                        baseGroupModel = NormalGroupModel.deserialize(from: d as! Dictionary)!
                        baseGroupModel.isRoot = false
                        baseGroupModel.isGroup = true
                        baseGroupModel.type = 0
                        
                        // 获取普通组下的条目
                    }else{
                        
                        baseGroupModel = NormalGroupModel.deserialize(from: d as! Dictionary)!
                        baseGroupModel.isRoot = false
                        baseGroupModel.isGroup = true
                        baseGroupModel.type = 0
                        
                    }
                    
                    // 获取其他组的条目
                }else{
                    
                    switch groupTpye{
                        
                    case 1:
                        
                        baseGroupModel = TimeGroupModel.deserialize(from: d as! Dictionary)!
                        baseGroupModel.isRoot = false
                        baseGroupModel.isGroup = true
                        baseGroupModel.type = 1
                    case 2:
                        
                        baseGroupModel = MultiGroupModel.deserialize(from: d as! Dictionary)!
                        baseGroupModel.isRoot = false
                        baseGroupModel.isGroup = true
                        baseGroupModel.type = 2
                        
                    case 3:
                        
                        baseGroupModel = ImageGroupModel.deserialize(from: d as! Dictionary)!
                        baseGroupModel.isRoot = false
                        baseGroupModel.isGroup = true
                        baseGroupModel.type = 3
                        
                    default:
                        print("组类型解析失败")
                        return
                        
                    }
                    
                    
                    
                    
                }
                
                
                
                
            }
            
            
            /*[ApplyVirginModel]()*/
            for dataItems in baseGroupModel.items!{
                
                // 如果是组的情况
                if dataItems.itemtype == "G"{
                    
                    switch dataItems.groupType{
                        
                    // 普通组
                    case "C"?:
                        let normalGroupModel = NormalGroupModel()
                        normalGroupModel.isGroup = true
                        normalGroupModel.type = 0
                        normalGroupModel.optionList = dataItems.value as? [Option]
                        
                        moveDataToSecondModel(withDataItemsModel: dataItems, withSecondBaseExampleModel: normalGroupModel, withMArry: &(baseGroupModel.secondItems!))
                        
                    // 多条组
                    case "M"?:
                        let multiGroupModel = MultiGroupModel()
                        multiGroupModel.isGroup = true
                        multiGroupModel.type = 2
                        multiGroupModel.num = dataItems.maxItem
                        multiGroupModel.optionList = dataItems.value as? [Option]
                        
                        moveDataToSecondModel(withDataItemsModel: dataItems, withSecondBaseExampleModel: multiGroupModel, withMArry: &(baseGroupModel.secondItems!))
                        
                    // 多条图片组
                    case "U"?:
                        let imageGroupModel = ImageGroupModel()
                        imageGroupModel.isGroup = true
                        imageGroupModel.type = 3
                        imageGroupModel.picNum = dataItems.maxItem
                        imageGroupModel.optionList = dataItems.value as? [Option]
                        
                        moveDataToSecondModel(withDataItemsModel: dataItems, withSecondBaseExampleModel: imageGroupModel, withMArry: &(baseGroupModel.secondItems!))
                        
                    // 时间点组与 时间段组
                    case "P"?,"T"?:
                        let timeGroupModel = TimeGroupModel()
                        timeGroupModel.isGroup = true
                        timeGroupModel.type = 1
                        timeGroupModel.itemNumber = dataItems.itemNumber
                        timeGroupModel.itemUnit = dataItems.itemUnit
                        timeGroupModel.optionList = dataItems.value as? [Option]
                        
                        moveDataToSecondModel(withDataItemsModel: dataItems, withSecondBaseExampleModel: timeGroupModel, withMArry: &(baseGroupModel.secondItems!))
                    default:
                        print("组匹配失败")
                        
                    }
                    
                    // 是字段的情况
                }else if dataItems.itemtype == "F"{
                    
                    switch dataItems.fieldType{
                        
                    // 多段
                    case 1110?:
                        let longTextModel = LongTextModel()
                        longTextModel.isGroup = false
                        longTextModel.type = 1
                        longTextModel.isWrap = true
                        longTextModel.maxLength = dataItems.maxLength
                        moveDataToSecondModel(withDataItemsModel: dataItems, withSecondBaseExampleModel: longTextModel, withMArry: &(baseGroupModel.secondItems!))
                    // 单段
                    case 1120?:
                        let longTextModel = LongTextModel()
                        longTextModel.isGroup = false
                        longTextModel.type = 1
                        longTextModel.isWrap = false
                        longTextModel.maxLength = dataItems.maxLength
                        moveDataToSecondModel(withDataItemsModel: dataItems, withSecondBaseExampleModel: longTextModel, withMArry: &(baseGroupModel.secondItems!))
                    // 普通短文本
                    case 1210?:
                        let shortTextModel = ShortTextModel()
                        shortTextModel.isAllNum = false
                        shortTextModel.isGroup = false
                        shortTextModel.maxLength = dataItems.maxLength
                        shortTextModel.type = 0
                        moveDataToSecondModel(withDataItemsModel: dataItems, withSecondBaseExampleModel: shortTextModel, withMArry: &(baseGroupModel.secondItems!))
                    // 数字
                    case 1220?:
                        let shortTextModel = ShortTextModel()
                        shortTextModel.isAllNum = true
                        shortTextModel.isGroup = false
                        shortTextModel.maxLength = dataItems.maxLength
                        shortTextModel.type = 0
                        moveDataToSecondModel(withDataItemsModel: dataItems, withSecondBaseExampleModel: shortTextModel, withMArry: &(baseGroupModel.secondItems!))
                    // 有后缀
                    case 1241?, 1242?, 1243?, 1244?, 1245?, 1246?, 1247?:
                        let shortTextModel = ShortTextModel()
                        shortTextModel.isAllNum = true
                        shortTextModel.isGroup = false
                        shortTextModel.suffix = dataItems.fieldSuffix
                        shortTextModel.type = 0
                        moveDataToSecondModel(withDataItemsModel: dataItems, withSecondBaseExampleModel: shortTextModel, withMArry: &(baseGroupModel.secondItems!))
                        
                    // 图片
                    case 2000?:
                        let imageModel = ImageModel()
                        imageModel.isGroup = false
                        imageModel.type = 2
                        imageModel.picNum = 1
                        imageModel.picUrl = dataItems.value as! String
                        moveDataToSecondModel(withDataItemsModel: dataItems, withSecondBaseExampleModel: imageModel, withMArry: &(baseGroupModel.secondItems!))
                        
                        
                    // 可预览附件
                    case 3100?:
                        let enclosureModel = EnclosureModel()
                        enclosureModel.isGroup = false
                        enclosureModel.type = 3
                        enclosureModel.url = dataItems.value as! String
                        
                        moveDataToSecondModel(withDataItemsModel: dataItems, withSecondBaseExampleModel: enclosureModel, withMArry: &(baseGroupModel.secondItems!))
                        
                    // 日期
                    case 4100?:
                        let timePointModel = TimePointModel()
                        timePointModel.isGroup = false
                        timePointModel.type = 7
                        timePointModel.dateString = dataItems.value as! String
                        
                        moveDataToSecondModel(withDataItemsModel: dataItems, withSecondBaseExampleModel: timePointModel, withMArry: &(baseGroupModel.secondItems!))
                        
                    // 单选
                    case 9110?, 9120?, 9130?:
                        let singlePickModel = SingleModel()
                        singlePickModel.isGroup = false
                        singlePickModel.type = 4
                        singlePickModel.option = dataItems.value as! [Option]
                        
                        moveDataToSecondModel(withDataItemsModel: dataItems, withSecondBaseExampleModel: singlePickModel, withMArry: &(baseGroupModel.secondItems!))
                        
                    // 联动单选
                    case 9210?:
                        let linkageModel = LinkageModel()
                        linkageModel.isGroup = false
                        linkageModel.type = 6
                        linkageModel.options = dataItems.value as! [Option]
                        
                        moveDataToSecondModel(withDataItemsModel: dataItems, withSecondBaseExampleModel: linkageModel, withMArry: &(baseGroupModel.secondItems!))
                        
                    // 多选多
                    case 9310?, 9320?, 9330?, 9340?, 9350?, 9390?:
                        let multiModel = MultiModel()
                        multiModel.isGroup = false
                        multiModel.type = 5
                        multiModel.options = dataItems.value as! [Option]
                        
                        moveDataToSecondModel(withDataItemsModel: dataItems, withSecondBaseExampleModel: multiModel, withMArry: &(baseGroupModel.secondItems!))
                        
                        
                    default:
                        print("组匹配失败")
                        
                        
                    }
                    
                }else{
                    
                    print("出现了一个不属于字或者段的组件")
                }
            }
            
            
            closure(resultCode, message,baseGroupModel)
        }
        
      
        
    }
    
    
    
    //MARK: 1.11 新建条目实例
    /// (组件)新建条目实例 [组件ID,申请实例ID等,具体条目ID?(保存具体条目实例数据时必填),多条组ID,条目名称]
    public class func newComponentEntry(withComponentId componentId: Int, withApplyId applyid: Int, withParam param: NewsEntryComponent,withLoginName loginName:String?, withPassword password:String?, _ closure: @escaping ((ResultCode, String)->())){
        
        // 拼接地址
        let urlString = "/component/" + "\(String(componentId))" + "/" + "\(String(applyid))"
        
        //请求参数
        let dict = [
            "itemInstance"  : param.itemInstance as Any,
            "formItemId"    : param.formItemId!,
            "value"         : param.value!
            ] as [String : Any]
        
        Session.session(withStringAction: urlString, withMethod: .PUT, withParam: dict, withLoginName: loginName, withPassword: password) { (resultCode, message, data) in
            
            guard let d = data else {
                closure(resultCode, message)
                return
            }
            
            closure(resultCode, message)
        }
        
        
    }
    
    //MARK: 1.12 删除条目实例
    /// (组件)删除条目实例  组件 申请实例 多条组ID或多条图片组 条目实例id
    public class func deleteComponentEntry(withComponentId componentId: Int, withApplyId applyid: Int, withFormItemId formItemId: Int,  withItemInstanceId itemInstanceid: Int,withLoginName loginName:String?, withPassword password:String?, _ closure: @escaping ((ResultCode, String)->())){
        
        // 拼接地址
        let urlString = "/component/" + "\(componentId)" + "/" + "\(applyid)" + "/" + "\(formItemId)" + "/" + "\(itemInstanceid)"
        
        //请求
        Session.session(withStringAction: urlString, withMethod: .DELETE, withParam: nil, withLoginName: loginName, withPassword: password) { (resultCode, message, data) in
            
            guard let d = data else {
                closure(resultCode, message)
                return
            }
            
            closure(resultCode, message)
        }
        
    }
    
    //MARK: 1.13 调整条目排序（上移/下移）
    /// (组件)调整条目排序 [组件id 申请实例id 多条组ID或多条图片组id 条目实例id direction:"up" "down"]
    public class func newComponentEntry(withComponentId componentId: Int, withApplyId applyid: Int, withFormItemId formItemId: Int,  withItemInstanceId itemInstanceid: Int,withDirection direction: DirectionAction!,withLoginName loginName:String?, withPassword password:String?,  _ closure: @escaping ((ResultCode, String)->())){
        
        // 拼接地址
        let urlString = "/component/" + "\(componentId)" + "/" + "\(applyid)" + "/" + "\(formItemId)" + "/" + "\(itemInstanceid)" + "/roll/" + "\(direction)"
        
        Session.session(withStringAction: urlString, withMethod: .POST, withParam: nil, withLoginName: loginName, withPassword: password) { (resultCode, message, data) in
            
            guard let d = data else {
                closure(resultCode, message)
                return
            }
            
            closure(resultCode, message)
        }
        
        
    }
    
    //MARK: 1.14 更新组件数据
    /// (组件)更新组件数据 [组件ID,申请实例ID,具体条目ID(保存具体条目实例数据时必填),字段ID,字段值(类型取决于字段类型配置)]
    public class func updateComponent(withComponentId componentId: Int, withApplyId applyid: Int, withItemInstanceId itemInstanceid: Int?, withFormItemId formItemId: Int,  withVaule vaule: Any,withLoginName loginName:String?, withPassword password:String?, _ closure: @escaping ((ResultCode, String)->())){
        
        // 拼接地址
        let urlString = "/component/" + "\(String(componentId))" + "/" + "\(String(applyid))"
        
        //请求参数
        let dict = [
            "itemInstance"  : itemInstanceid as Any,
            "formItemId"    : formItemId,
            "value"         : vaule
            ] as [String : Any]
        
        Session.session(withStringAction: urlString, withMethod: .PUT, withParam: dict, withLoginName: loginName, withPassword: password) { (resultCode, message, data)  in
            
            guard let d = data else {
                closure(resultCode, message)
                return
            }
            
            closure(resultCode, message)
        }
        
        
    }
    
    
    //MARK: 1.15 更新组件数据(图片及附件上传)
    /// (组件)更新组件数据 [组件ID,申请实例ID,图片/附件字段ID或多条图片组ID,具体条目ID（保存具体条目实例数据时必填）,file]
    public class func updateComponentWithImg(withComponentId componentId: Int, withApplyId applyid: Int, withItemInstanceId itemInstanceid: Int?, withFormItemId formItemId: Int,  withFile img: UIImage, withLoginName loginName:String?, withPassword password:String?,_ closure: @escaping ((Progress,ReturnUploadImage?)->())){

        // 拼接地址
        let urlString = "/component/" + "\(String(componentId))" + "/" + "\(String(applyid))"
        + "/" + "\(String(formItemId))"
        
        /*
        ajax.put('/component/:id/:applyId/:formItemId', {
            itemInstance: <long>, // （可选）具体条目ID（保存具体条目实例数据时必填）
            file: <File> // 图片文件
        });
        return {
         */
            
        let imageData = UIImagePNGRepresentation(img)!
        
        var dic : [String : Any] = [String : Any]()
        
        if itemInstanceid == nil  {
            
            dic = [
                "file": imageData
            ]
            
        }else{
            
            dic = [
                "itemInstance": itemInstanceid!,
                "file": imageData
            ]
        }
        
        
        guard JSONSerialization.isValidJSONObject(dic) else{
            print("its not json")
            return
        }
        
        let dicData = try?JSONSerialization.data(withJSONObject: dic, options:[])
        
        
        // 转换
        var returnString = String()
        
        var require: URLRequest! =  URLRequest(url: URL(string: urlString)!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        require.setValue("\(loginName)", forHTTPHeaderField: "userID")
        let sha1Password = password?.sha1()
        let sha1PasswordLow = sha1Password?.lowercased()
        require.setValue("\(sha1PasswordLow)", forHTTPHeaderField: "password")
        
            require.httpBody = imageData
            
            let session = URLSession.shared
            var task: URLSessionDataTask

            task = session.uploadTask(with: require, from: dicData){
                resultData, response, error in
                
                if let err = error{
                    print("error: \(err)")
                    return
                }
                
                
                print("response: \(response)")
                print("resultData: \(resultData)")
            }

            task.resume()
        
        
        

        
    }
    
    //MARK: 1.16 判断企业是否收藏政策(未收藏为空 收藏返回收藏对象) [policyId 政策ID]
    /// 判断企业是否收藏政策(未收藏为空 收藏返回收藏对象)
    public class func getIsCompanyBookmarkApply(withPolicyId policyId: Int, withLoginName loginName:String?, withPassword password:String?, _ closure: @escaping ((ResultCode, String,BookmarkPolicyVirginModel?)->())){
        
        // 拼接地址
        let urlString = "/policy/" + "\(policyId)" + "/bookmark"
        
        //
        
        Session.session(withStringAction: urlString, withMethod: .GET, withParam: nil, withLoginName: loginName, withPassword: password) { (resultCode, message, data) in
            
            guard let d = data else {
                closure(resultCode, message, nil)
                return
            }
//
//            let jsonArrayString: String? = getJSONStringFromDictionary(dictionary: d)
            let bookmarkPolicyVirginModel = BookmarkPolicyVirginModel.deserialize(from: d as! Dictionary)
            
            closure(resultCode, message,bookmarkPolicyVirginModel!)
        }
        
    }
    
    //MARK: 1.17 新增申请实例[policyId 政策ID]
    /// 1.17 新增申请实例[policyId 政策ID]
    public class func newApplyInstance(withPolicyId policyId: Int, withLoginName loginName:String?, withPassword password:String?, _ closure: @escaping ((ResultCode, String,ApplyInstance?)->())){
        
        // 拼接地址
        let urlString = "/apply"
        
        
        let param = ["policyId"  : policyId
                    ]
        
        
        Session.session(withStringAction: urlString, withMethod: .POST, withParam: param, withLoginName: loginName, withPassword: password) { (resultCode, message, data) in
            
            guard let d = data else {
                closure(resultCode, message ,nil)
                return
            }
            
//            let jsonArrayString: String? = getJSONStringFromDictionary(dictionary: d)
            let bookmarkPolicyVirginModel = ApplyInstance.deserialize(from: d as! Dictionary)
            
            closure(resultCode, message,bookmarkPolicyVirginModel!)
        }
        
        
    }
    
    //MARK: 1.18 收藏或取消收藏政策
    /// 1.18 收藏或取消收藏政策[policyId 政策ID,action:bookmark - 收藏； cancelBookmark - 取消收藏]
    public class func bookmarkOrcancelBookmark(withPolicyId policyId: Int,withAction action:CollectActoin!,withLoginName loginName:String?, withPassword password:String?,  _ closure: @escaping ((ResultCode, String)->())){
        
        // 拼接地址
        let urlString = "/apply" + "\(policyId)" + "/" + "action"
        Session.session(withStringAction: urlString, withMethod: .POST, withParam: nil, withLoginName: loginName, withPassword: password) { (resultCode, message, data) in
            
            guard let d = data else {
                closure(resultCode, message)
                return
            }
            closure(resultCode, message)
        }
        
    }
    
    
    //MARK: 1.19 用户登录
    /// 1.19 用户登录 []
    
    public class func userLogin(withLoginName phoneNumber:String, withPassword password:String,  _ closure: @escaping ((ResultCode, String,UsrInformationModel?)->())){
        let urlString = "/user/session/" + phoneNumber
        
        
        Session.session(withStringAction: urlString, withPassword: password) { (resultCode, message, data) in
            
            guard let d = data else {
                closure(resultCode, message, nil)
                return
            }
            
            
            let usrInformationModel = UsrInformationModel.deserialize(from: d as! Dictionary)
            
            closure(resultCode, message,usrInformationModel)
            
        }
        
    }
    
    //MARK: 1.20 用户注销
    /// 1.20 用户注销
    public class func userLogout(withLoginName loginName:String?, withPassword password:String?, _ closure: @escaping ((ResultCode, String)->())){
        
        let urlString = "/user/session/" + loginName!
        
        Session.session(withStringAction: urlString, withMethod: .DELETE, withParam: nil, withLoginName: loginName, withPassword: password) { (resultCode, message, data)in
            
            closure(resultCode, message)
        }
        
    }
    
    //MARK: 1.21 获取用户信息
    /// 1.21 获取用户信息
    public class func getUserMessage(withLoginName loginName:String?, withPassword password:String?, _ closure: @escaping ((ResultCode, String,UsrInformationModel?)->())){
        
        
        let urlString = "/user/session/"
        
        Session.session(withStringAction: urlString, withMethod: .GET, withParam: nil, withLoginName: loginName, withPassword: password) { (resultCode, message, data) in
            
            guard let d = data else {
                closure(resultCode, message, nil)
                return
            }
            
//            let jsonArrayString: String? = getJSONStringFromDictionary(dictionary: d)
            let usrInformationModel = UsrInformationModel.deserialize(from: d as! Dictionary)
            
            closure(resultCode, message,usrInformationModel)
        }
        
    }
    
    
    
    
    
    static var phoneNumber: String?
    //MARK: 1.22 用户注册
    /// 1.22 用户注册
    
    public class func userRegister(withRegisterStep registerStep: RegisterStep, withValue value: Any, _ closure: @escaping ((ResultCode, String)->())){
        
        switch registerStep {
        case .verifyCode:
            let urlString = "/user"
            let postParam = ["mobile":value]
            
            Session.session(withStringAction: urlString, withMethod: .POST, withParam: postParam, closure: {(resultCode, message, data) in
                
                if resultCode == .success{
                    phoneNumber = value as? String
                }
                closure(resultCode, message)
            })
            
        case .legal:
            guard let number = phoneNumber else{
                closure(.failure, "need phonenumber")
                return
            }
            
            let urlString = "/user/" + number + "/verifyCode/" + String(describing: value)
            Session.session(withStringAction: urlString, withMethod: .POST, withParam: nil, closure: { (resultCode, message, data) in
                
                closure(resultCode, message)
            })
            
        case .register:
            
            
            guard let number = phoneNumber, let password = value as? String else{
                closure(.failure, "need phonenumber")
                return
            }
            let urlString = "/user/" + number
            let postParam = ["password": password.sha1()]
            
            Session.session(withStringAction: urlString, withMethod: .POST, withParam: postParam, closure: { (resultCode, message, data) in
                
                closure(resultCode, message)
            })
        
        }
    }
    
    
    
    //MARK: 1.23 找回密码
    /// 1.2 找回密码
    static var mobile: String!
    public class func getbackPasswordStep(withGetbackPasswordStep getbackPasswordStep: getbackPasswordStep, withValue value: Any, _ closure: @escaping ((ResultCode, String)->())){
        
        switch getbackPasswordStep {
        case .verifyCode:
            
            let urlString = "/user/reset"
            let postParam = ["mobile":value]
            
            Session.session(withStringAction: urlString, withMethod: .POST, withParam: postParam, closure: { (resultCode, message, data)  in
                
                if resultCode == .success{
                    mobile = value as? String
                }
                closure(resultCode, message)
            })
            
            
        case .legal:
            guard let number = mobile else{
                closure(.failure, "need phonenumber")
                return
            }
            
            let urlString = "/user/reset/" + number + "/verifyCode/" + String(describing: value)
            Session.session(withStringAction: urlString, withMethod: .POST, withParam: nil, closure: { (resultCode, message, data) in
                
                closure(resultCode, message)
            })
            
        case .reset:
            
            
            guard let number = mobile, let password = value as? String else{
                closure(.failure, "need phonenumber")
                return
            }
            let urlString = "/user/reset/" + number
            let postParam = ["password": password.sha1()]
            
            Session.session(withStringAction: urlString, withMethod: .POST, withParam: postParam, closure: { (resultCode, message, data) in
                
                closure(resultCode, message)
            })
            
           
        }
    }
    
    
    //MARK: 1.23 重设密码
    /// 1.23 重设密码
    public class func resetPassword(withLoginName loginName:String!,withOldPassword oldPassword:String!, withNewPassword newPassword:String!, _ closure: @escaping ((ResultCode, String)->())){
        
        
        let urlString = "/user"
        let postParam = ["oldPassword": oldPassword.sha1(),
                         "newPassword": newPassword.sha1()]
        Session.session(withStringAction: urlString, withMethod: .PUT, withParam: postParam, withLoginName: loginName, withPassword: oldPassword) { (resultCode, message, data) in
            
            guard let d = data else {
                closure(resultCode, message)
                return
            }
            closure(resultCode, message)
        }
        
    }
    
    //MARK: 1.24 扫码登录
    /// 1.24 扫码登录

    public class func qrcodeLogin(withLoginName loginName:String?, withPassword password:String?,withUuid uuid:String!, _ closure: @escaping ((ResultCode, String)->())){
        
        
        let urlString = "/qrcode/" + "\(uuid)" + "/login"
        Session.session(withStringAction: urlString, withMethod: .POST, withParam: nil, withLoginName: loginName, withPassword: password) { (resultCode, message, data)  in
            
            guard let d = data else {
                closure(resultCode, message)
                return
            }
            closure(resultCode, message)
        }
        
    }
    
    /*
     /**
     * 扫码下载附件
     * @param *uuid <String>扫码获取的UUID
     * @param url <String>下载链接
     */
     ajax.post('/qrcode/:uuid/download', {
     url: <String> // 下载链接
     });
     */
    //MARK: 1.25 扫码下载附件
    ///1.25 扫码下载附件
    
    public class func qrcodeDownload(withLoginName loginName:String?, withPassword password:String?,withUuid uuid:String!, withDownloadUrl downloadUrl:String!, _ closure: @escaping ((ResultCode, String)->())){
        
        
        let urlString = "/qrcode/" + "\(uuid)" + "/download"
        let postParam = ["url": downloadUrl]
        Session.session(withStringAction: urlString, withMethod: .POST, withParam: postParam, withLoginName: loginName, withPassword: password) { (resultCode, message, data) in
            
            guard let d = data else {
                closure(resultCode, message)
                return
            }
            closure(resultCode, message)
        }
        
    }
    
    
}
//MARK: 2. 一些有用的方法

/// 字典转JSONString
///
/// - Parameter dictionary: 传入的字典
/// - Returns: JSONString
func getJSONStringFromDictionary(dictionary: Any?) -> String? {
    guard let dic = dictionary else{
        print("its empty")
        return nil
    }
    guard JSONSerialization.isValidJSONObject(dic) else {
        print("无法解析出JSONString")
        return nil
    }
    do{
        let data  = try? JSONSerialization.data(withJSONObject: dic, options: JSONSerialization.WritingOptions.prettyPrinted)
        let JSONString = String(data: data!, encoding: String.Encoding.utf8)
        return JSONString
    }catch let error{
        print("try error \(error)")
        return nil
    }
}

/// 将处女数据属性转移到二次处理中
///
/// - Parameters:
///   - dataItems: 处女数据模型
///   - baseExampleModel: 二次模型
func moveDataToSecondModel(withDataItemsModel dataItems:DataItems, withSecondBaseExampleModel baseExampleModel:BaseExampleModel, withMArry  mArray: inout [BaseExampleModel]) ->Void{
    
    baseExampleModel.title = dataItems.title
    baseExampleModel.status = dataItems.status
    baseExampleModel.hint = dataItems.hint
    baseExampleModel.id = dataItems.id
    mArray.append(baseExampleModel)
}
