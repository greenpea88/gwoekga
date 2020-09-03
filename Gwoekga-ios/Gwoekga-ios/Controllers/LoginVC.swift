//
//  LoginVC.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/08/31.
//  Copyright © 2020 minchae. All rights reserved.
//
import UIKit
import Toast_Swift // 오픈소스 : https://github.com/scalessec/Toast-Swift

class LoginVC: KeyBoardNoti, UIGestureRecognizerDelegate, UITextFieldDelegate {

    //TODO: 로그인 입력 정보 맞는지 확인하기 + 이미 로그인 되어있는 경우 다음 화면으로 바로 넘어가기
    
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

    //MARK: - IBAction Method
    @IBAction func onLoginBtnClicked(_ sender: UIButton) {
        print("LoginVC -> onLoginBtnClicked()")
        
        guard let id = idTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        if (id.isEmpty || password.isEmpty){
            self.view.makeToast("ID,password를 모두 입력해주세요.",duration: 1.0,position: .center)
        }
        //로그인시 홈 화면으로 넘어가기
        else{
            //스토리보드 가져오기
            let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
            //스토리보드를 통해 view controller 가져오기
            let homeVC = storyboard.instantiateViewController(withIdentifier: "tabBarHome")
            //전환 타입
            homeVC.modalPresentationStyle = .fullScreen
            homeVC.modalTransitionStyle = .crossDissolve
            
            //전환 
            self.present(homeVC,animated: true,completion: nil)
        }

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
    
    //MARK: - UITextFieldDelegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //텍스트 필드에서 유저가 return키를 눌렀을 때
        print("LoginVC -> textField returnClicked()")
        
        guard let id = idTextField.text else {return false}
        guard let password = passwordTextField.text else {return false}
        
        if (id.isEmpty || password.isEmpty){
            self.view.makeToast("ID,password를 모두 입력해주세요.",duration: 1.0,position: .center)
            return false
        }
        else{
            textField.resignFirstResponder()
            
            //스토리보드 가져오기
            let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
            //스토리보드를 통해 view controller 가져오기
            let homeVC = storyboard.instantiateViewController(withIdentifier: "tabBarHome")

            //전환 타입
            homeVC.modalPresentationStyle  = .fullScreen
            homeVC.modalTransitionStyle = .crossDissolve

            self.present(homeVC,animated: true,completion: nil)
            
            return true
        }

    }
    
    //MARK: - KeyBoardNoti override
   @objc override func keyboardWillShow(notification: NSNotification){
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
    
    @objc override func keyboardWillHide(notification: NSNotification){

            print("LoginVC -> keyboardWillHide()")
            
            self.view.frame.origin.y = 0

        }
    
}
