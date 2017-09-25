//
//  PolicyCheckVC.swift
//  government_park
//
//  Created by YiGan on 20/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class PolicyCheckVC: UIViewController {
    
    
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    
    var policyContents: String?{
        didSet{
            if let contents = policyContents {
                textView.text = contents
            }else{
                textView.text = "无政策内容"
            }
        }
    }
    
    //MARK:- init-------------------------------------
    override func viewDidLoad() {
        
        config()
        createContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        
    }
    
    @IBAction func close(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
    }
}
