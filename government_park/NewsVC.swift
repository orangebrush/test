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
}
