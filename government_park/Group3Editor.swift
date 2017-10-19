//
//  Group3Editor.swift
//  government_park
//
//  Created by YiGan on 21/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
class Group3Editor: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var maxCount = 10
    var valueList = [Value]()           //图片数据
    
    var applyId = 0
    var componentId = 0
    var groupId = 0
    var instanceId: Int?
    
    var fieldTypeValue = 0
    
    
    //MARK:- init-----------------------------------------------------
    override func viewDidLoad() {
        
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        createContents()
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        collectionView.reloadData()
    }
    
    //MARK: 删除已有图片
    @IBAction func deleteSelectedPhoto(_ sender: Any) {
        
//        guard let index = selectorIndex, index < maxCount else {
//            return
//        }
//
//        data.remove(at: index)
    }
}

//MARK:- collection delegate
extension Group3Editor: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if valueList.count < maxCount {
            return valueList.count + 1
        }
        return maxCount
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let id = "cell"
        let row = indexPath.row
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath) as! Group3CollectionCell
        if row == valueList.count {
            //添加加号按钮图标
            cell.backgroundColor = .green
        }else{
            let value = valueList[row]
            if let imageStr = value.title{
                if let imageURL = URL(string: imageStr){
                    DispatchQueue.global().async {
                        do{
                            if let imageData = try? Data(contentsOf: imageURL){
                                let image = UIImage(data: imageData)
                                DispatchQueue.main.async {
                                    cell.imageView.image = image
                                }
                            }
                        }catch let error{
                            print("load image error: \(error)")
                        }
                    }
                }
            }
        }
        return cell
    }
    
    //MARK: 点击展开图片
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let row = indexPath.row
        if valueList.count < maxCount && row + 1 == valueList.count{
            //添加新照片
        }else{
            //展开操作
        }
    }
    
    //MARK: 移动顺序
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    //MARK: 定义尺寸
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //返回等同于窗口大小的尺寸
        let length = view_size.width / 3
        
        return CGSize(width: length, height: length)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
