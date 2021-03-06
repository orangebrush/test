//
//  Field3Editor.swift
//  government_park
//
//  Created by YiGan on 20/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//附件编辑器

import UIKit
class Field3Editor: FieldEditor {
    
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var remindLabel: UILabel!
    
    var urlString: String?
    
    //MARK:- init-----------------------------------------
    override func viewDidLoad() {
        
        config()
        createContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        if let urlStr = urlString {
//            let url = URL(string: urlStr)
//        }
    }
    
    private func config(){
        remindLabel.text = "请使用网页版上传"
        remindLabel.font = .middle
        remindLabel.textColor = .gray
    }
    
    private func createContents(){
        
    }
    
    //MARK: 删除附件
    @IBAction func deleteEnclosure(_ sender: Any) {
    }
}

//MARK:- webview delegate
extension Field3Editor: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
    }
}
