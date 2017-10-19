//
//  Session.swift
//  gov_sdk
//
//  Created by YiGan on 12/10/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit

let host = "http://139.199.7.78:8080/zhjf-v2"
let mainSession = URLSession.shared

class Session {
    class func session(withAction action: String, withMethod method: String, withParam param: Any, closure: @escaping Closure) {
        
        //回调函数
        let completionHandler = {(binaryData: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else{
                closure(ResultCode.failure, "连接服务器错误", nil)
                debugPrint("<Session> 请求错误: \(String(describing: error))")
                return
            }
            
            do{
                guard let result = try JSONSerialization.jsonObject(with: binaryData!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: Any] else{
                    closure(ResultCode.failure, "获取数据错误", nil)
                    return
                }
                
                debugPrint("<Session> result:")
                print(result)
                
                guard let code = result["code"] as? Int, let message = result["message"] as? String else {
                    closure(.failure, "解析数据错误", nil)
                    return
                }
                
                let data = result["result"]
                
                //根据返回码判断
                closure(code == 0 ? .success : .failure, message, data)
                
            }catch let responseError{
                debugPrint("<Session> 数据处理错误: \(responseError)")
            }
        }
        
        //post or get
        let isPost = method == Method.post
        do{
            
            var urlStr = host + action
            if !isPost {
                let dict = param as! [String: Any]
                for (offset: index, element: (key: key, value: value)) in dict.enumerated(){
                    if index == 0{
                        urlStr += "?"
                    }else{
                        urlStr += "&"
                    }
                    let v = value as! String
                    urlStr.append(key + "=" + v)
                }
                
                print("<Session> \(action)- url: \(urlStr)")
            }
            
            //生成url
            guard let url = URL(string: urlStr) else{
                return
            }
            
            var request: URLRequest!
            if isPost {
                request =  URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
                request.httpMethod = method
                
                //与用户相关请求采用form格式
                
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                var form = ""
                let dict = param as! [String: Any]
                for (offset: index, element: (key: key, value: value)) in dict.enumerated() {
                    if index != 0 {
                        form += "&"
                    }
                    let v = value as! String
                    form.append(key + "=" + v)
                }
                request.httpBody = form.data(using: .utf8)
                
                print("<Session> \(action)- url: \(url)")
                /*
                 let body = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions.prettyPrinted)
                 request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                 request.httpBody = body
                 */
            }
            
            let session = URLSession.shared
            var task: URLSessionDataTask
            if isPost {
                task = session.dataTask(with: request, completionHandler: completionHandler)
            }else{
                task = session.dataTask(with: url, completionHandler: completionHandler)
            }
            task.resume()
        }catch let error{
            debugPrint("<Session> 解析二进制数据错误: \(error)")
        }
    }
    
    //MARK:-上传图片
    class func upload(_ image: UIImage, withAction action: String, withParams param: Any, closure: @escaping (_ resultCode: ResultCode, _ message:String, _ data: Any?) -> ()){
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
                
                guard let code = result["code"] as? Int, let message = result["message"] as? String else {
                    closure(ResultCode.failure, "解析数据错误", nil)
                    return
                }
                
                guard code == 0 else {
                    closure(.failure, message, nil)
                    return
                }
                closure(.success, message, result["result"])
                
            }catch let responseError{
                debugPrint("<Session> 数据处理错误: \(responseError)")
            }
        }
        
        //上传
        guard let imgData = UIImagePNGRepresentation(image) else {
            return
        }
        
        let urlStr = host + action
        
        //生成url
        guard let url = URL(string: urlStr) else{
            return
        }
        
        
        //裸上传
        let boundary = "ganyiisbestplayerintheworld"
        let headerString = "multipart/form-data; charset=utf-8; boundary=" + boundary
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        
        request.setValue(headerString, forHTTPHeaderField: "Content-Type")
        
        var mutableData = Data()
        
        let dict = param as! [String: Any]
        var myString = "--" + boundary + "\r\n"
        
        //添加参数
        for (offset: index, element: (key: key, value: value)) in dict.enumerated() {
            myString += "Content-Disposition: form-data; name=\"" + key + "\"\r\n\r\n"
//            myString += "Content-Type: text/plain; charset=UTF-8\r\n"
//            myString += "Content-Transfer-Encoding: 8bit\r\n\r\n"
            myString += value as! String
            myString += "\r\n--" + boundary + "\r\n"

        }
        
        let interval = Int(Date().timeIntervalSince1970)
        
        //添加文件
        myString += "Content-Disposition: form-data; name=\"file\"; filename=\"" + "\(interval)" + ".png\"\r\n"
        myString += "Content-Type: image/png\r\n\r\n"
//        myString += "Content-Transfer-Encoding: binary\r\n\r\n"
        
        mutableData.append(myString.data(using: .utf8)!)
        mutableData.append(imgData)
        mutableData.append(("\r\n--" + boundary + "--\r\n").data(using: .utf8)!)
        
        request.httpBody = mutableData
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
    }
}
