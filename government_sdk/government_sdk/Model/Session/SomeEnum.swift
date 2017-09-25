//
//  SomeEnum.swift
//  NetWorkSDK
//
//  Created by X Young. on 2017/9/20.
//  Copyright © 2017年 XinRui. All rights reserved.
//

import Foundation

/// 网络请求类型
///
/// - GET: GET
/// - POST: POST
/// - PUT: PUT
enum Method:String{
    
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    
}

/// 当前网络连接类型
///
/// - NotReachable: 网络不可用
/// - ReachableViaWWAN: 流量
/// - ReachableViaWiFi: Wifi
enum MobileNetType{
    case NotReachable
    case ReachableViaWWAN
    case ReachableViaWiFi
}


public enum ResultCode{
    case failure
    case success
}

let resultCodeDict = [
    
    ////////////////////////////////////////////
    // ZhjfUnauthorizedException
    ////////////////////////////////////////////
    "401101":"未登录 / Session Timeout",
    "401102":"用户名密码错误 / Token校验失败",
    "401103":"用户名/Token不能为空",
    
    
    ////////////////////////////////////////////
    // ZhjfForbiddenException
    ////////////////////////////////////////////
    "403111":"企业用户专用",
    "403112":"企业管理员专用",
    "403121":"政府用户专用",
    "403122":"政府领导专用",
    "403131":"无组织用户专用",
    "403141":"匿名用户专用",
    
    
    ////////////////////////////////////////////
    // ZhjfNotFoundException
    ////////////////////////////////////////////
    "404101":"用户不存在",
    "404102":"企业不存在",
    "404103":"注册企业申请不存在",
    "404104":"加入企业申请不存在",
    "404201":"政策不存在",
    "404202":"目录不存在",
    "404203":"组件不在目录中",
    "404204":"资助ID不存在或者不属于当前政策",
    "404205":"高级字段不存在",
    "404206":"无效的材料清单ID",
    "404301":"申请实例不存在",
    "404401":"组件不存在",
    "404402":"组件实例不存在",
    "404403":"组/字段不存在",
    "404404":"错误的组件ID或组/字段ID",
    "404405":"申请资金组件不存在",
    "404406":"勾选资助字段不存在",
    "404407":"资金总额字段不存在",
    "404408":"申请概要组件不存在",
    "404409":"条目实例不存在",
    "404410":"附件不存在",
    "404501":"政策新闻不存在",
    "404601":"Markdown库不存在",
    "404602":"附件库不存在",
    "404603":"业务附属说明不存在",
    
    ////////////////////////////////////////////
    // ZhifCompanyException
    ////////////////////////////////////////////
    
    
    "400101":"您已注册或加入企业",
    "400102":"无法删除管理员",
    "400103":"该手机号已注册",
    "400104":"短信验证码已失效",
    "400105":"短信验证码错误",
    "400106":"操作已超时，请重新注册",
    "400107":"该手机号尚未注册",
    "400108":"操作已超时，请重新重置密码",
    "400190":"发送短信验证码出错",
    "400191":"发送短信验证码出错",
    "400192":"下载企业营业执照照片出错",
    
    ////////////////////////////////////////////
    // ZhjfPolicyException
    ////////////////////////////////////////////
    
    
    "400201":"你已收藏过该政策",
    "400202":"你尚未收藏过该政策",
    "400203":"组件不属于当前申请政策",
    "400204":"政策不在编辑状态",
    "400205":"组件不在目录中",
    
    ////////////////////////////////////////////
    // ZhjfApplyException
    ////////////////////////////////////////////
    
    
    "400301":"无效的状态类型",
    "400302":"尚有未完结申请，无法创建新申请",
    "400303":"当前申请不在编辑状态",
    "400304":"无法提交申请",
    "400305":"无法取消申请",
    "400306":"无法移除申请",
    "400307":"无法撤回申请",
    "400308":"无法驳回申请",
    "400309":"无法批准申请",
    "400310":"无法预约办理时间",
    "400311":"无法线下驳回申请",
    "400312":"无法线下批准申请",
    "400313":"无法中断申请",
    "400314":"无法填写备注",
    "400315":"无法标记申请",
    "400316":"必须提供驳回理由",
    "400317":"必须提供预约时间和对接人",
    "400318":"必须提供线下驳回理由",
    "400319":"必须提供中断理由",
    "400320":"必须提供备注信息",
    "400321":"联系人已存在",
    
    ////////////////////////////////////////////
    // ZhjfComponentException
    ////////////////////////////////////////////
    
    
    "400401":"条目实例ID不能为空",
    "400402":"无法删除条目实例",
    "400403":"无法更新组的值",
    "400404":"值不能为空，如果要删除条目请调用专用接口",
    "400405":"重复的条目名称",
    "400406":"请调用图片上传接口上传图片或附件",
    "400407":"无效的数字",
    "400408":"无效的数值",
    "400409":"无效的百分比",
    "400410":"无效的时间戳",
    "400411":"无效的高级字段值",
    "400412":"无效的json字符串",
    "400413":"无效的条目实例",
    "400490":"读取组件数据出错",
    "400491":"获取申请奖项数据失败",
    "400492":"更新组件时间组信息失败",
    "400493":"调整条目序号失败",
    "400494":"删除条目实例失败",
    "400495":"上传文件失败",
    "400496":"下载附件失败",
    "400497":"更新组件时间组信息失败",
    
    
    ////////////////////////////////////////////
    // ZhjfNewsException
    ////////////////////////////////////////////
    
    
    "400501":"只支持单文件上传",
    "400590":"上传文件失败",
    "400591":"获取政策新闻图片失败",
    
    ////////////////////////////////////////////
    // ZhjfLibraryException
    ////////////////////////////////////////////
    
    
    "400690":"文件获取失败",
    
    ////////////////////////////////////////////
    // ZhjfUnsupportOperationException
    ////////////////////////////////////////////
    
    
    "400999":"暂不支持的操作",
    
    
    ////////////////////////////////////////////
    // 其他异常，具体信息详见Message
    ////////////////////////////////////////////
    
    
    "400997":"NestedRuntimeException",
    "400998":"ServletException",
    "500999":"INTERNAL_SERVER_ERROR",

];

