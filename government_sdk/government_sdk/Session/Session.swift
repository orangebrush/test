//
//  Session.swift
//  NetWorkSDK
//
//  Created by X Young. on 2017/9/19.
//  Copyright © 2017年 XinRui. All rights reserved.
//

import UIKit

// FIXME:待接口文档出来之后更新主地址
let hostUrlStr: String = "http://139.199.7.78:8080/zhjf"

class Session {
    
    
    class func session(withAction action: Actions, withMethod type: Method, withParam param: Any, closure: @escaping (_ resultCode: ResultCode, _ message:String, _ data: [String: Any]?) -> ()) {
        
        //回调函数
        let completionHandler = {
            (binaryData: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else{
                closure(ResultCode.failure, "连接服务器错误", nil)
                debugPrint("<Session> 请求错误: \(String(describing: error))")
                return
            }
            
            do{
                guard let result = try JSONSerialization.jsonObject(with: binaryData!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] else{
                    closure(ResultCode.failure, "json error", nil)
                    
                    //print("具体出错原因========>%@",ResultCodeDict[((error! as NSError).userInfo)["Code"] as! String]!)
                    return
                }
                
                debugPrint("<Session> result: \(result)")
                
                //失败判断
                //                if let code = result["Code"] as? String{
                //                    guard let errorMessage = resultCodeDict[code] else{
                //                        closure(ResultCode.failure, "unkown error", nil)
                //                    }
                //                    closure(ResultCode.failure, errorMessage, nil)
                //                    return
                //                }
                
                guard let resultCode = result["Code"] as? String  else {
                    
                    var msg = "empty"
                    if let message = result["Message"] as? String {
                        msg = message
                    }
                    closure(.success, msg, result)

                    return
                }
                closure(ResultCode.failure, "unkown error", nil)
                
            }catch let responseError{
                debugPrint("<Session> 数据处理错误: \(responseError)")
                //print("具体出错原因========>%@",ResultCodeDict[((error! as NSError).userInfo)["Code"] as! String]!)
            }
        }
        
        //post or get
        let isPost = type == Method.POST
        do{
            
            var urlStr = hostUrlStr + action.rawValue
            if true || !isPost {
                let dict = param as! [String: Any]
                for (offset: index, element: (key: key, value: value)) in dict.enumerated(){
                    if index == 0{
                        urlStr += "?"
                    }else{
                        urlStr += "&"
                    }
                    var v: String
                    if value is String{
                        v = value as! String
                    }else{
                        v = "\(value)"
                    }
                    urlStr.append(key + "=" + v)
                }
            }
            
            print("urlStr: \(urlStr)")
            
            //生成url
            guard let url = URL(string: urlStr) else{
                return
            }
            
            var request: URLRequest!
            if false && isPost {
                request =  URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
                request.httpMethod = type.rawValue
                
                let body = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = body
            }
            
            let session = URLSession.shared
            var task: URLSessionDataTask
            if false && isPost {
                task = session.dataTask(with: request, completionHandler: completionHandler)
            }else{
                task = session.dataTask(with: url, completionHandler: completionHandler)
            }
            task.resume()
        }catch let error{
            debugPrint("<Session> 解析二进制数据错误: \(error)")
            //print("具体出错原因========>%@",ResultCodeDict[((error! as NSError).userInfo)["Code"] as! String]!)
        }
    }
    
    //MARK:-上传图片
    class func upload(_ image: UIImage, userid: String, closure: @escaping (_ resultCode: ResultCode, _ message:String, _ data: Any?) -> ()){
        //回调函数
        let completionHandler = {(binaryData: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else{
                closure(ResultCode.failure, "error", nil)
                debugPrint("<Session> 请求错误: \(String(describing: error))")
                return
            }
            
            do{
                guard let result = try JSONSerialization.jsonObject(with: binaryData!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] else{
                    closure(ResultCode.failure, "获取数据错误", nil)
                    return
                }
                
                debugPrint("<Session> result: \(result)")
                
                guard let resultCode = result["Code"] as? String, let message = result["Message"] as? String else {
                    closure(ResultCode.failure, "解析数据错误", nil)
                    return
                }
                
                if resultCode == "0"{
                    closure(.success, message, result)
                }else{
                    closure(.failure, message, nil)
                }
            }catch let responseError{
                debugPrint("<Session> 数据处理错误: \(responseError)")
            }
        }
        
        //上传
        guard let imgData = UIImagePNGRepresentation(image) else {
            return
        }
        
        
        // FIXME:拼接请求地址
        let urlStr = hostUrlStr //+ Actions.uploadPhoto
        

        
        //生成url
        guard let url = URL(string: urlStr) else{
            return
        }
        
        let boundary = "gansdlfajlsjdfa12"
        let headerString = "multipart/form-data; charset=utf-8; boundary=" + boundary
        
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        request.httpMethod = "POST"
        
        request.setValue(headerString, forHTTPHeaderField: "Content-Type")
        
        var mutableData = Data()
        var myString = "--" + boundary + "\r\n"
        myString += "Content-Disposition: form-data; name=\"userId\"\r\n"
        myString += "Content-Type: text/plain; charset=UTF-8\r\n"
        myString += "Content-Transfer-Encoding: 8bit\r\n\r\n"
        myString += userid
        
        myString += "\r\n--" + boundary + "\r\n"
        myString += "Content-Disposition: form-data; name=\"file\"; filename=\"" + userid + ".png\"\r\n"
        myString += "Content-Type: image/png\r\n"
        myString += "Content-Transfer-Encoding: binary\r\n\r\n"
        
        mutableData.append(myString.data(using: .utf8)!)
        mutableData.append(imgData)
        mutableData.append(("\r\n--" + boundary + "--\r\n").data(using: .utf8)!)
        
        request.httpBody = mutableData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
        
        
    }
    
    
}

