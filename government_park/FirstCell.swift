//
//  FirstCell.swift
//  government_park
//
//  Created by YiGan on 18/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
import gov_sdk
class FirstCell: UITableViewCell {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var closure: ((News)->())?
    
    //新闻数据
    var data: AllNewsData?{
        didSet{
            guard let d = data else {
                return
            }
            
            //移除已有新闻
            for subView in scrollView.subviews{
                subView.removeFromSuperview()
            }
            
            let newsList = d.newsList
            let count = newsList.count
            
            scrollView.contentSize = CGSize(width: .edge8 + (new_size.width + .edge8) * CGFloat(count), height: new_size.height)
            
            //添加新闻
            for (index, news) in newsList.enumerated(){

                //创建imageview
                let imageFrame = CGRect(x: .edge8 + CGFloat(index) * (.edge8 + new_size.width), y: 0, width: new_size.width, height: new_size.width)
                let imageView = UIImageView(frame: imageFrame)
                imageView.isUserInteractionEnabled = true
                imageView.tag = index
                scrollView.addSubview(imageView)
                
                //添加点击事件
                let tap = UITapGestureRecognizer(target: self, action: #selector(clickImage(tap:)))
                tap.numberOfTapsRequired = 1
                tap.numberOfTouchesRequired = 1
                imageView.addGestureRecognizer(tap)
                
                //创建label
                let labelFrame = CGRect(x: .edge8 + CGFloat(index) * (.edge8 + new_size.width), y: new_size.width + .edge8, width: new_size.width, height: .labelHeight * 2)
                let label = UILabel(frame: labelFrame)
                label.font = .tiny
                label.numberOfLines = 2
                label.textColor = .subWord
                label.text = news.title
                scrollView.addSubview(label)
                
                //获取图片
                if let imgUrl = news.picUrl{
                    do{
                        let imgData = try Data(contentsOf: imgUrl)
                        let image = UIImage(data: imgData)
                        imageView.image = image
                    }catch let error{
                        print("loading image error: \(error)")
                    }
                }
            }
        }
    }
    
    //MARK:- init-------------------------------------------------------------------
    override func didMoveToSuperview() {

        config()
        createContents()
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        
    }
    
    //MARK: 图片点击回调
    @objc func clickImage(tap: UITapGestureRecognizer){
        guard let tag = tap.view?.tag else {
            return
        }
        
        guard let news = data?.newsList[tag] else{
            return
        }
        
        closure?(news)
    }
}

//MARK:- scrollview delegate
extension FirstCell: UIScrollViewDelegate{
    
}
