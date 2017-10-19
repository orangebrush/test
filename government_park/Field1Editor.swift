//
//  Field1Editor.swift
//  government_park
//
//  Created by YiGan on 20/09/2017.
//  Copyright © 2017 YiGan. All rights reserved.
//长文本编辑器

import UIKit
import gov_sdk
class Field1Editor: FieldEditor {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var charactersLabel: UILabel!        
    
    var text: String?
    
    //MARK:- init---------------------------------------------------
    override func viewDidLoad() {
        
        config()
        createContents()
    }
    
    private func config(){
        charactersLabel.font = .small
        charactersLabel.textColor = .lightGray
    }
    
    private func createContents(){
        textView.text = text
        
        if let t = text{
            let leftCharactersCount = maxLength * 4 - t.characters.count
            charactersLabel.text = "剩余\(leftCharactersCount)字符"
        }
    }
    
    //MARK: 保存
    @IBAction func save(_ sender: Any) {
        guard let t = textView.text else {
            return
        }
        let saveFieldParams = SaveFieldParams()
        saveFieldParams.applyId = applyId
        saveFieldParams.componentId = componentId
        saveFieldParams.fieldId = fieldId
        saveFieldParams.instanceId = instanceId
        saveFieldParams.value = t
        NetworkHandler.share().field.saveField(withSaveFieldParams: saveFieldParams) { (resultCode, message, data) in
            DispatchQueue.main.async {
                guard resultCode == .success else{
                    self.notif(withTitle: message, closure: nil)
                    return
                }
                
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

//MARK:- text view delegate
extension Field1Editor: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let existedLength = textView.text?.lengthOfBytes(using: .utf8)
        let selectedLength = range.length
        let replaceLength = text.lengthOfBytes(using: .utf8)
        
        let currentLength = existedLength! - selectedLength + replaceLength
        if currentLength > maxLength * 4{
            return false
        }
        
        //计算剩余字符
        let leftCharactersCount = maxLength * 4 - currentLength
        charactersLabel.text = "剩余\(leftCharactersCount)字符"
        
        return true
    }
}
