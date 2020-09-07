//
//  LoginVC.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/08/31.
//  Copyright © 2020 minchae. All rights reserved.
//
import UIKit
import Toast_Swift // 오픈소스 : https://github.com/scalessec/Toast-Swift
import NaverThirdPartyLogin //네이버 아이디로 로그인

class LoginVC: KeyBoardNoti, NaverThirdPartyLoginConnectionDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate {
    

    //TODO: 로그인 입력 정보 맞는지 확인하기 + 이미 로그인 되어있는 경우 다음 화면으로 바로 넘어가기
    //TODO: 다른 화면에서 로그아웃시 네이버 아이디로 로그인한 것 로그아웃 처리 어떻게??  -> 토큰은 1시간이 지나면 만료됨
    
    
    @IBOutlet weak var test: UIButton!
    @IBOutlet weak var naverLoginBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var loginInfoField: UIStackView!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var notJoinYet: UIButton!
    
    //키보드를 내리기위한 tabGesture
    var keyboardDissmissTabGesture: UIGestureRecognizer = UIGestureRecognizer(target: self, action: nil)
    
    //네이버 아이디 로그인
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //상단 네비게이션 바 부분 숨김 처리
        self.navigationController?.isNavigationBarHidden = true
        loginBtn.layer.cornerRadius = loginBtn.frame.height / 2
        naverLoginBtn.layer.cornerRadius = naverLoginBtn.frame.height / 2
        
        //설정하지 않으면 delegate를 감지하지 못함
        self.idTextField.delegate = self
        self.passwordTextField.delegate = self
        self.keyboardDissmissTabGesture.delegate = self
        self.naverLoginInstance?.delegate = self
        
        //gesture 감지할 수 있도록 설정
        self.view.addGestureRecognizer(keyboardDissmissTabGesture)
    }
    
    //MARK: - fileprivate
    fileprivate func enterHome(){
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
            enterHome()
        }

    }
    
    @IBAction func onNaverLoginBtnClicked(_ sender: UIButton) {
        print("LoginVC -> onNaverLoginBtnClicked()")

        naverLoginInstance?.requestThirdPartyLogin()
        
    }
    
    @IBAction func test(_ sender: UIButton) {
        naverLoginInstance?.requestDeleteToken()
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
        else if(touch.view?.isDescendant(of: naverLoginBtn) == true){
            return false
        }
        else if(touch.view?.isDescendant(of: test) == true){
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
                if(screenHight < keyboardSize.height + naverLoginBtn.frame.origin.y + naverLoginBtn.frame.height){
                    //키보드가 버튼을 덮음
                    let distance = screenHight - keyboardSize.height - naverLoginBtn.frame.origin.y - naverLoginBtn.frame.height
                    self.view.frame.origin.y = distance - 10
                }
            }
        }
    
    @objc override func keyboardWillHide(notification: NSNotification){

            print("LoginVC -> keyboardWillHide()")
            
            self.view.frame.origin.y = 0

        }
    
    //MARK: - NaverThirdPartyLoginConnectionDelegate Method
    //로그인 성공시 호출
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("LoginVC -> login is Success")
        enterHome()
    }
    //접근 토근 갱신
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        
    }
    //토큰 삭제(로그아웃 시 사용)
    func oauth20ConnectionDidFinishDeleteToken() {
        print("LoingVC -> logout")
    }
    
    //error
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("Login VC -> error occur / \(error.localizedDescription)")
    }
    
}

