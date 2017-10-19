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
    
    fileprivate var selectedValue: Value?
    
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
        
        guard let selValue = selectedValue else {
            notif(withTitle: "未选择", closure: nil)
            return
        }
        
        //删除图片
        let deleteInstanceParams = DeleteInstanceParams()
        deleteInstanceParams.applyId = applyId
        deleteInstanceParams.componentId = componentId
        deleteInstanceParams.groupId = groupId
        deleteInstanceParams.instanceId = selValue.id
        NetworkHandler.share().editor.deleteInstance(withDeleteInstanceParams: deleteInstanceParams) { (resultCode, message, data) in
            DispatchQueue.main.async {
                self.notif(withTitle: message, closure: nil)
                guard resultCode == .success else{
                    return
                }
                
                if let index = self.valueList.index(of: selValue){
                    self.valueList.remove(at: index)
                    self.collectionView.reloadData()
                }
            }
        }
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
            cell.imageView.image = nil
            cell.backgroundColor = .green
        }else{
            cell.backgroundColor = nil
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
        if row == valueList.count{
            //添加新照片
            let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "相册", "拍照")
            actionSheet.show(in: view)
        }else{
            //展开操作
            let value = valueList[row]
            selectedValue = value
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

//MARK:- action sheet delegate
extension Group3Editor: UIActionSheetDelegate{
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        switch buttonIndex {
        case 0:
            print("close")
        case 1:
            selectPhotoFromLibrary()
        case 2:
            selectPhotoFromCamera()
        default:
            print("other")
        }
    }
    
    //MARK:从照片库中挑选图片
    fileprivate func selectPhotoFromLibrary(){
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else{
            let alertController = UIAlertController(title: "拍照", message: "相机获取图片失效", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.modalPresentationStyle = .currentContext
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK:从相机中拍摄图片
    fileprivate func selectPhotoFromCamera(){
        
        guard UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) else{
            let alertController = UIAlertController(title: "相册", message: "获取相册图片失效", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = UIImagePickerControllerSourceType.camera
        cameraPicker.modalPresentationStyle = .currentContext
        cameraPicker.allowsEditing = false
        //        cameraPicker.cameraOverlayView = ? 覆盖在相机上
        cameraPicker.showsCameraControls = true
        cameraPicker.cameraDevice = .rear
        present(cameraPicker, animated: true, completion: nil)
    }
}

//MARK:照片库delegate
extension Group3Editor: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        //上传照片
        let saveFileParams = SaveFileParams()
        saveFileParams.image = image
        saveFileParams.applyId = applyId
        saveFileParams.componentId = componentId
        saveFileParams.fromItemId = groupId
        saveFileParams.instanceId = instanceId
        NetworkHandler.share().field.saveFile(withSaveFileParams: saveFileParams) { (resultCode, message, tuple) in
            DispatchQueue.main.async {
                self.notif(withTitle: message, closure: nil)
                guard resultCode == .success else{
                    return
                }
                guard let urlStr = tuple?.0, let id = tuple?.1 else{
                    return
                }
                let newValue = Value()
                newValue.id = id
                newValue.title = urlStr
                self.valueList.append(newValue)
                self.collectionView.reloadData()
            }
        }
        picker.dismiss(animated: true){}
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true){}
    }
}
