//
//  NewsVC.swift
//  government_park
//
//  Created by YiGan on 22/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
import gov_sdk
class NewsVC: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var news: News?
    
    //MARK:- init------------------------------------------------
    override func viewWillAppear(_ animated: Bool) {
        
        guard let n = news else {
            return
        }
        
        //更新标题
        navigationItem.title = n.title
        
        //更新内容
        if let url = n.url{
            let urlRequest = URLRequest(url: url)
            webView.loadRequest(urlRequest)
        }
    }
    
    //MARK: 分享
    @IBAction func share(_ sender: Any) {
        
        let ganAlert = GANAlertAction()
        view.addSubview(ganAlert)
    }
    
    func shareFramBotton(_ notif:Notification){
        // 12345
        let titleStr = "Come join me,kick balls！"
        let urlStr = "https://itunes.apple.com/cn/app/freesball/id1073361604?l=zh&ls=1&mt=8"
        print("\nshareBy:\(notif.object!)")
        switch notif.object as! Int{
        case 1:
            print("分享至微信好友")
            //            let req = SendMessageToWXReq()
            //            req.scene = Int32(WXSceneSession.rawValue)
            //            req.text = "文字标题"
            //            req.bText = true
            //            WXApi.sendReq(req)
            
            let title = ""//"\(getData(.UserInfo, key: Key.Highscore))" + titleStr
            let message = WXMediaMessage()
            message.title = title
            message.description = "FreesBall"
            message.setThumbImage(UIImage(named: "180"))
            
            let ext = WXWebpageObject()
            ext.webpageUrl = urlStr
            
            message.mediaObject = ext
            
            let req = SendMessageToWXReq()
            req.bText = false
            req.message = message
            req.scene = Int32(WXSceneSession.rawValue)
            
            WXApi.send(req)
        case 2:
            print("分享至朋友圈")
            
            let title = "开发者的字体工具"//"\(getData(.UserInfo, key: Key.Highscore)!)" + titleStr
            let message = WXMediaMessage()
            message.title = title
            message.description = "集合iOS所有系统字体，自定义选择收藏查看，对于开发途中预览大有益脾"//"FreesBall"
            message.setThumbImage(UIImage(named: "fonticon"))
            
            let ext = WXWebpageObject()
            ext.webpageUrl = "https://itunes.apple.com/us/app/fonts-for-designer/id1198088551?l=zh&ls=1&mt=8"//urlStr
            
            message.mediaObject = ext
            
            let req = SendMessageToWXReq()
            req.bText = false
            req.message = message
            req.scene = Int32(WXSceneTimeline.rawValue)
            
            WXApi.send(req)
        default:
            break
        }
    }
}
