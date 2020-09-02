//
//  JoinVC.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/08/31.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit
import Toast_Swift // 오픈소스 : https://github.com/scalessec/Toast-Swift

class JoinVC: UIViewController, UIGestureRecognizerDelegate,UITextFieldDelegate {
    
    //TODO: 입력된 정보가 이미 가입된 회원인지 확인(id값으로 확인/username은 중복 사용 가능)
    //회원가입한 경우 = 로그인 바로 다음화면으로 넘어가기
    
    @IBOutlet weak var joinBtn: UIButton!
    @IBOutlet weak var joinInfoField: UIStackView!
    @IBOutlet weak var registeredBtn: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var welcomeView: UIView!
    
    
    var keyboardDissmissTabGesture: UIGestureRecognizer = UIGestureRecognizer(target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //상단 네비게이션 바 부분 숨김 처리
        self.navigationController?.isNavigationBarHidden = true
        joinBtn.layer.cornerRadius = joinBtn.frame.height / 2
        
        self.keyboardDissmissTabGesture.delegate = self
        self.usernameTextField.delegate = self
        self.idTextField.delegate = self
        self.passwordTextField.delegate = self
        
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
        print("JoinVC -> viewWillDisappear()")
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - IBAction Methods
    @IBAction func onRegisteredBtnClicked(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onJoinBtnClicked(_ sender: UIButton) {
        
        guard let username = usernameTextField.text else {return}
        guard let id = idTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        if (username.isEmpty || id.isEmpty || password.isEmpty){
            self.view.makeToast("회원 정보를 모두 입력해주세요.",duration: 1.0,position: .center)
        }
        //TODO: 회원 가입 시 홈 화면으로 넘어가기 + welcome 화면 띄우기
        else{
            //키보드 내리기
            self.view.endEditing(true)
            
            //키보드 내려간 후 딜레이 주고 welcome 화면 띄우기
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.welcomeView.isHidden = false
            })
            
            //view 전환
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                //스토리보드 가져오기
                let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
                //스토리보드를 통해 view controller 가져오기
                let homeVC = storyboard.instantiateViewController(withIdentifier: "tabBarHome")
                            //전환 타입
                homeVC.modalPresentationStyle = .fullScreen
                homeVC.modalTransitionStyle = .crossDissolve
                
                self.present(homeVC,animated: true,completion: nil)
            })
        }
    }
    
    
    //MARK: - @objc
    @objc func keyboardWillShow(notification: NSNotification){
        //키보드가 버튼 가리는만큼 화면 올리기
        print("JoinVC -> keyboardWillShow()")

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

        print("JoinVC -> keyboardWillHide()")
        
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
    
    //MARK: - UITextFieldDelegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //텍스트 필드에서 유저가 return키를 눌렀을 때
        print("JoinVC -> textField returnClicked()")
        
        guard let username = usernameTextField.text else {return false}
        guard let id = idTextField.text else {return false}
        guard let password = passwordTextField.text else {return false}
        
        if (username.isEmpty || id.isEmpty || password.isEmpty){
            self.view.makeToast("회원 정보를 모두 입력해주세요.",duration: 1.0,position: .center)
            return false
        }
        else{
            textField.resignFirstResponder()
            
            //키보드 내려간 후 딜레이 주고 welcome 화면 띄우기
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.welcomeView.isHidden = false
            })
            
            //view 전환
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                //스토리보드 가져오기
                let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
                //스토리보드를 통해 view controller 가져오기
                let homeVC = storyboard.instantiateViewController(withIdentifier: "tabBarHome")
                            //전환 타입
                homeVC.modalPresentationStyle = .fullScreen
                homeVC.modalTransitionStyle = .crossDissolve
                
                self.present(homeVC,animated: true,completion: nil)
            })
            return true
        }

    }
}
