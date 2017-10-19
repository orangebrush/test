//
//  CreateCompanyVC.swift
//  government_park
//
//  Created by YiGan on 19/10/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import Foundation
class CreateCompanyVC: UIViewController {
    
    @IBOutlet weak var companyNameTextfield: UITextField!
    @IBOutlet weak var companyOrgCodeTextfield: UITextField!
    @IBOutlet weak var companyFileImageView: UIImageView!
    
    fileprivate var fileImage: UIImage?{
        didSet{
            companyFileImageView.image = fileImage
        }
    }
    
    //MARK:- init------------------------------------------------
    override func viewDidLoad() {
        config()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setTabbar(hidden: true)
        createContents()
    }
    
    private func config(){
        
        companyNameTextfield.text = localCompanyName
        companyOrgCodeTextfield.text = localOrg
    }
    
    private func createContents(){
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: 返回
    @IBAction func back(_ sender: Any){
        navigationController?.popViewController(animated: true)
    }
    @IBAction func addFile(_ sender: UITapGestureRecognizer) {
        let actionSheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "取消", destructiveButtonTitle: nil, otherButtonTitles: "相册", "拍照")
        actionSheet.show(in: view)
    }
    
    //MARK: 开始企业认证
    @IBAction func certify(_ sender: Any){
        
        guard let companyName = companyNameTextfield.text, let companyOrg = companyOrgCodeTextfield.text, let image = fileImage else {
            notif(withTitle: "内容需填写", closure: nil)
            return
        }
        
        //存储
        userDefaults.set(companyName, forKey: "companyName")
        userDefaults.set(companyOrg, forKey: "org")
        
        let registerCompanyParams = RegisterCompanyParams()
        registerCompanyParams.name = companyName
        registerCompanyParams.orgCode = companyOrg
        registerCompanyParams.file = image.transfromImage(size: CGSize(width: 640, height: 750))
        NetworkHandler.share().me.registerCompany(withParams: registerCompanyParams) { (resultCode, message, data) in
            DispatchQueue.main.async {
                self.notif(withTitle: message, closure: nil)
                guard resultCode == .success else{
                    return
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}


//MARK:- action sheet delegate
extension CreateCompanyVC: UIActionSheetDelegate{
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
extension CreateCompanyVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        fileImage = image
        picker.dismiss(animated: true){}
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true){}
    }
}


//MARK:- text field delegate
extension CreateCompanyVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    //点击return事件
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false 
    }
    
    //键盘弹出
    func keyboardWillShow(notif:NSNotification){
        let userInfo = notif.userInfo
        
        let keyboardBounds = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        let offset = keyboardBounds.size.height
        
        /*
         let animations = {
         let keyboardTransform = CGAffineTransform(translationX: 0, y: -offset)
         self.lowNiavigation.transform = keyboardTransform
         }
         
         if duration > 0 {
         let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
         UIView.animate(withDuration: duration, delay: 0, options: options, animations: animations, completion: nil)
         }else{
         animations()
         }
         */
    }
    
    //键盘回收
    func keyboardWillHide(notif:NSNotification){
        let userInfo = notif.userInfo
        
        let duration = (userInfo![UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        /*
         let animations = {
         let keyboardTransform = CGAffineTransform.identity
         self.lowNiavigation.transform = keyboardTransform
         }
         
         if duration > 0 {
         let options = UIViewAnimationOptions(rawValue: UInt((userInfo![UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
         UIView.animate(withDuration: duration, delay: 0, options: options, animations: animations, completion: nil)
         }else{
         animations()
         }
         */
    }
    
    //复制判断
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let existedLength = textField.text?.lengthOfBytes(using: .utf8)
//        let selectedLength = range.length
//        let replaceLength = string.lengthOfBytes(using: .utf8)
//
//        if existedLength! - selectedLength + replaceLength > maxLength{
//            return false
//        }
//
//        return true
//    }
}
