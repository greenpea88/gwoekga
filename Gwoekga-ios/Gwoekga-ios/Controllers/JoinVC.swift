//
//  JoinVC.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/08/31.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit

class JoinVC: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var joinBtn: UIButton!
    @IBOutlet weak var joinInfoField: UIStackView!
    @IBOutlet weak var registeredBtn: UIButton!
    
    
    
    var keyboardDissmissTabGesture: UIGestureRecognizer = UIGestureRecognizer(target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //상단 네비게이션 바 부분 숨김 처리
        self.navigationController?.isNavigationBarHidden = true
        joinBtn.layer.cornerRadius = joinBtn.frame.height / 2
        
        self.keyboardDissmissTabGesture.delegate = self
        self.view.addGestureRecognizer(keyboardDissmissTabGesture)
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
    @IBAction func onRegisteredBtnClicked(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - @objc
    @objc func keyboardWillShow(notification: NSNotification){
        //키보드가 버튼 가리는만큼 화면 올리기
        print("LoginVC -> keyboardWillShow()")

        //키보드 사이즈 가져오기
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            let screenHight = UIScreen.main.bounds.height
            if(screenHight < keyboardSize.height + joinBtn.frame.origin.y + joinBtn.frame.height){
                //키보드가 버튼을 덮음
                let distance = screenHight - keyboardSize.height - joinBtn.frame.origin.y - joinBtn.frame.height
                self.view.frame.origin.y = distance - 10
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification){

        print("LoginVC -> keyboardWillHide()")
        
        self.view.frame.origin.y = 0

    }
    
    
    //MARK: - UIGestureRecognizerDelegate Method
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("JoinVC -> gestureRecodnizer touch()")
        
        //화면 터치했을 때 키보드 내려가도록
        if (touch.view?.isDescendant(of: joinBtn) == true){
            return false
        }
        else if(touch.view?.isDescendant(of: joinInfoField) == true){
            return false
        }
        else if(touch.view?.isDescendant(of: registeredBtn) == true){
            return false
        }
        else{
            view.endEditing(true)
            return true
        }
    }
}
