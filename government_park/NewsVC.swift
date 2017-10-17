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
    private let ganAlert = GANAlertAction()
    
    
    var news: News?
    
    //MARK:- init------------------------------------------------
    override func viewDidLoad() {
        view.addSubview(ganAlert)
        
        NotificationCenter.default.addObserver(self, selector: #selector(shareFromBotton(_:)), name: NSNotification.Name(rawValue: kNotifShared), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kNotifShared), object: nil)
    }
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        webView.stopLoading()
        webView.delegate = nil
        ganAlert.removeFromSuperview()
    }
    
    //MARK: 分享
    @IBAction func share(_ sender: Any) {
        ganAlert.swip()
    }
    
    func shareFromBotton(_ notif:Notification){
        // 12345
        guard let n = news else {
            return
        }
        let title = n.title

        switch notif.object as! Int{
        case 1:
            print("分享至微信好友")
            //            let req = SendMessageToWXReq()
            //            req.scene = Int32(WXSceneSession.rawValue)
            //            req.text = "文字标题"
            //            req.bText = true
            //            WXApi.sendReq(req)
            
            let message = WXMediaMessage()
            message.title = title
            message.description = ""
            message.setThumbImage(UIImage(named: "180"))
            
            let ext = WXWebpageObject()
            ext.webpageUrl = n.url?.absoluteString ?? ""
            
            message.mediaObject = ext
            
            let req = SendMessageToWXReq()
            req.bText = false
            req.message = message
            req.scene = Int32(WXSceneSession.rawValue)
            
            WXApi.send(req)
        case 2:
            print("分享至朋友圈")
            
            let message = WXMediaMessage()
            message.title = title
            message.description = ""
            message.setThumbImage(UIImage(named: "fonticon"))
            
            let ext = WXWebpageObject()
            ext.webpageUrl = n.url?.absoluteString ?? ""
            
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
