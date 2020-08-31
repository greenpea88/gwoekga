//
//  LoginVC.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/08/31.
//  Copyright © 2020 minchae. All rights reserved.
//
import UIKit
import Toast_Swift // 오픈소스 : https://github.com/scalessec/Toast-Swift

class LoginVC: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {

    //TODO: 정보 입력안하면 toast 띄우기
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loginInfoField: UIStackView!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var notJoinYet: UIButton!
    
    var keyboardDissmissTabGesture: UIGestureRecognizer = UIGestureRecognizer(target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //상단 네비게이션 바 부분 숨김 처리
        self.navigationController?.isNavigationBarHidden = true
        loginBtn.layer.cornerRadius = loginBtn.frame.height / 2
        
        //설정하지 않으면 delegate를 감지하지 못함
        self.idTextField.delegate = self
        self.passwordTextField.delegate = self
        self.keyboardDissmissTabGesture.delegate = self
        
        //gesture 감지할 수 있도록 설정
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
    @IBAction func onLoginBtnClicked(_ sender: UIButton) {
        print("LoginVC -> onLoginBtnClicked()")

    }

    //MARK: - @objc
    @objc func keyboardWillShow(notification: NSNotification){
        //키보드가 버튼 가리는만큼 화면 올리기
        print("LoginVC -> keyboardWillShow()")

        //키보드 사이즈 가져오기
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            let screenHight = UIScreen.main.bounds.height
            if(screenHight < keyboardSize.height + loginBtn.frame.origin.y + loginBtn.frame.height){
                //키보드가 버튼을 덮음
                let distance = screenHight - keyboardSize.height - loginBtn.frame.origin.y - loginBtn.frame.height
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
        //사용자가 터치했을 때 동작하게 됨
        
        if (touch.view?.isDescendant(of: loginBtn) == true){
            return false
        }
        else if(touch.view?.isDescendant(of: loginInfoField) == true){
            return false
        }
        else if(touch.view?.isDescendant(of: notJoinYet) == true){
            return false
        }
        else{
            //키보드 내림
            view.endEditing(true)
            return true
        }
    }
    
    //MARK: - UITextFieldDelegate
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        //텍스트 필드에서 유저가 return키를 눌렀을 때
//        print("LoginVC -> textField returnClicked()")
//
//
//    }

}
