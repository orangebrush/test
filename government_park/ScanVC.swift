//
//  ScanVC.swift
//  government_park
//
//  Created by YiGan on 25/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//

import UIKit
import AVFoundation
import gov_sdk
class ScanVC: UIViewController {
    
    //MARK:- 扫描初始--------------------------------------------------------------------------------
    //会话
    fileprivate lazy var session = AVCaptureSession()
    
    // 拿到输入设备
    private lazy var deviceInput : AVCaptureInput? = {
        
        // 获取摄像头
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do{
            let input = try AVCaptureDeviceInput(device: device)
            return input
        }catch{
            print(error)
            return nil
        }
    }()
    
    //拿到输出设备
    private lazy var deviceOutput = AVCaptureMetadataOutput()
    
    //预览图层
    fileprivate lazy var previewLayer : AVCaptureVideoPreviewLayer = {
        let lary = AVCaptureVideoPreviewLayer(session: self.session)
        lary?.frame = UIScreen.main.bounds
        return lary ?? AVCaptureVideoPreviewLayer()
    }()
    
    
    //MARK:- init---------------------------------------------------------
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        guard let input = self.deviceInput else{
            return
        }
        
        guard self.session.canAddInput(input) else {
            return
        }
        
        self.session.addInput(input)
        self.session.addOutput(deviceOutput)
        
        self.deviceOutput.metadataObjectTypes = self.deviceOutput.availableMetadataObjectTypes
        self.deviceOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        let height = view_size.width - CGFloat.edge16 * 2
        self.previewLayer.frame = CGRect(x: .edge16, y: (view_size.height - height) / 2, width: height, height: height)
        
        self.view.layer.addSublayer(self.previewLayer)
        
        self.session.startRunning()
    }
}

//MARK:- QRCode delegate
extension ScanVC: AVCaptureMetadataOutputObjectsDelegate{
    func captureOutput(_ output: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        guard metadataObjects.count > 0 else{
            return
        }
        
        self.session.stopRunning()
        self.previewLayer.removeFromSuperlayer()
        
        guard let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject else {
            return
        }
        
        if let uuid = metadataObject.stringValue{
            //登陆
            NetworkHandler.share().QR.login(withUUID: uuid) { (resultCode, message, data) in
                DispatchQueue.main.async {
                    guard resultCode == .success else{
                        self.notif(withTitle: message, closure: nil)
                        self.login()
                        return
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }else{
            notif(withTitle: "无法识别", closure: nil)
        }
    }
}
