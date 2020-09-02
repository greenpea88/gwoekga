//
//  PostVC.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/08/31.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit

class PostVC: UIViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var underStackView: UIStackView!
    @IBOutlet weak var titleTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PostVC -> viewDidLoad()")
        // Do any additional setup after loading the view.
        
        //title 입력 textfield에 포커스 주기
        self.titleTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //키보드가 올라가고 내려가고는 iphone에서 defualt로 notification을 보내줌
        //notification center 설치
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    //MARK: - IBAction Methods
    @IBAction func onCancleBtnClicked(_ sender: UIButton) {
        print("PostVC -> onCancleBtnClicked()")
        //이전 view로 되돌아감
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - @objc
    @objc func keyboardWillShow(notification: NSNotification){
        //키보드 올라오는만큼 아래바 올리기
       if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
//        self.underStackView.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
        self.underStackView.frame.origin.y = self.underStackView.frame.origin.y - keyboardSize.height
        }
        
    }

    @objc func keyboardWillHide(notification: NSNotification){
        //키보드 내려가면 원상복구
        print("PostVC -> keyboardWillHide()")
        self.underStackView.frame.origin.y = 0

    }
    
}
