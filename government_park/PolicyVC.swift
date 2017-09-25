//
//  Policy.swift
//  government_park
//
//  Created by YiGan on 19/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class PolicyVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var collectionButton: UIButton!
    
    private var image: UIImage?{
        didSet{
            
        }
    }
    private var imageView: UIImageView!
    
    //数据
    var data: Any?{
        didSet{
            
        }
    }
    
    //MARK:- init--------------------------------------------------
    override func viewDidLoad() {
        
        config()
        createContents()
    }
    
    private func config(){
        
        scrollView.contentSize = CGSize(width: view_size.width, height: view_size.height * 2)
        automaticallyAdjustsScrollViewInsets = false
    }
    
    private func createContents(){
        
        let imageFrame = CGRect(x: 0, y: 0, width: view_size.width, height: view_size.width * 9 / 16)
        imageView = UIImageView(frame: imageFrame)
        imageView.backgroundColor = .gray
        scrollView.addSubview(imageView)        
    }
    
    //MARK: 收藏
    @IBAction func collection(_ sender: UIButton) {
        collectionButton.isSelected = !collectionButton.isSelected
    }
    
    //MARK:- 申请或查看或继续编辑
    @IBAction func apply(_ sender: Any) {
        
        let editVC = UIStoryboard(name: "Edit", bundle: Bundle.main).instantiateViewController(withIdentifier: "edit")
        navigationController?.show(editVC, sender: nil)
    }
}
