//
//  NewsVC.swift
//  government_park
//
//  Created by YiGan on 22/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
import government_sdk
class NewsVC: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var newsModel: NewsModel?
    
    //MARK:- init------------------------------------------------
    override func viewWillAppear(_ animated: Bool) {
        
        guard let model = newsModel else {
            return
        }
        
        //更新标题
        navigationItem.title = model.title
        
        //更新内容
        if let url = model.contentUrl{
            let urlRequest = URLRequest(url: url)
            webView.loadRequest(urlRequest)
        }
    }
}
