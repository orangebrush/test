//
//  Field2Editor.swift
//  government_park
//
//  Created by YiGan on 20/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//图片编辑器

import UIKit
class Field2Editor: FieldEditor {
    
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    fileprivate var image: UIImage?{
        didSet{
            reImage()
        }
    }
    
    //MARK:- init----------------------------------------
    override func viewDidLoad() {
        
        config()
        createContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        reImage()
    }
    
    private func config(){
        
    }
    
    private func createContents(){
        
    }
    
    //MARK: 图片判定
    private func reImage(){
        imageView.image = image
        
        imageView.isHidden = image == nil
        addButton.isHidden = image != nil
        addButton.isEnabled = image == nil
    }
    
    //MARK: 添加图片
    @IBAction func addImage(_ sender: Any) {
        let actionSheet = UIActionSheet(title: "添加图片", delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "从相册", "从相机")
        actionSheet.show(in: view)
    }
    
    //MARK: 删除图片
    @IBAction func deleteImage(_ sender: Any) {
        image = nil
    }
}

//MARK:- action sheet delegate
extension Field2Editor: UIActionSheetDelegate{
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
        cameraPicker.allowsEditing = true
        //        cameraPicker.cameraOverlayView = ? 覆盖在相机上
        cameraPicker.showsCameraControls = true
        cameraPicker.cameraDevice = .front
        present(cameraPicker, animated: true, completion: nil)
    }
}

//MARK:照片库delegate
extension Field2Editor: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.image = image
        picker.dismiss(animated: true){}
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true){}
    }
}
