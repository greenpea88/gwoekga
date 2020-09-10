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
import Alamofire

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
    @IBOutlet weak var loadingView: UIView!
    
    var loadedReviews = [Review]()
    var sendReviews = [Review]()
    
    //키보드를 내리기위한 tabGesture
    var keyboardDissmissTabGesture: UIGestureRecognizer = UIGestureRecognizer(target: self, action: nil)
    
    //네이버 아이디 로그인
    let naverLoginInstance = NaverThirdPartyLoginConnection.getSharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //값이 저장되어있다면 자동 로그인
        if let userId = UserDefaults.standard.string(forKey: "id"){
            //로그인 실행
            //id 존재하면 화면 전환
        }
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
//        print("loginVC -> prepare() \(self.sendReviews)")
        switch segue.identifier {
        case SEGUE.JOIN:
            break
        case SEGUE.LOGIN_ENTER_HOME:
            let tabBarController = segue.destination as! CustomTabBarController
            let login = tabBarController.viewControllers?[0] as! HomeVC
            
            login.showReviews = self.sendReviews
            login.fromMainVeiw  = 1
        default:
            print("default")
        }
    }
    
    fileprivate func enterHome(){
//        //스토리보드 가져오기
//        let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
//        //스토리보드를 통해 view controller 가져오기
//        let homeVC = storyboard.instantiateViewController(withIdentifier: "tabBarHome")
//        //전환 타입
//        homeVC.modalPresentationStyle = .fullScreen
//        homeVC.modalTransitionStyle = .crossDissolve
//        //전환
//        self.present(homeVC,animated: true,completion: nil)
        //처음 화면이 로드될 때 불러와있을 정보들 -> 올라가있는 정보들 중 한 10개 정도만,,,?(최근 것부터~)
        
        let semaphore = DispatchSemaphore(value: 0)
        let loadingQueue = DispatchQueue.global()
        
        loadingQueue.async {
                        PostManager.shared.getPost(completion: {[weak self] result in
                       guard let self = self else {return}
                       
                       switch result{
                       case .success(let reviews):
                           //배열은 시간순으로 되어있으므로 뒤집기
                           self.loadedReviews = reviews.reversed()
                           self.sendReviews = Array(self.loadedReviews.prefix(5))
                       case .failure(let error):
                        print(error)
                       }
                semaphore.signal()
                   })
        }
        semaphore.wait(timeout: .now() + 5)
        DispatchQueue.main.async {
            //ui와 관련된 사항은 main thread에서 진행되어야 함
            //화면 전환 방법 segue로 변경
            self.performSegue(withIdentifier: SEGUE.LOGIN_ENTER_HOME, sender: self)
        }
    }
    
    fileprivate func getEmailFromNaver(){
        guard let isValidAccessToken = naverLoginInstance?.isValidAccessTokenExpireTimeNow() else {return}
        
        if !isValidAccessToken{
            //유효한 토큰이 없을 경우
            return
        }
        
        guard let tokenType = naverLoginInstance?.tokenType else {return}
        guard let accessToken = naverLoginInstance?.accessToken else {return}
        let url = "https://openapi.naver.com/v1/nid/me"
        
        let auth = "\(tokenType) \(accessToken)"
        
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization" : auth]).responseJSON { response in
            debugPrint(response)
        }
    }
    
    //MARK: - login operation
    fileprivate func autoLogin(){
        print("LoginVC -> autoLogin()")
        //앱에서 로그인을 했을 경우, 완전 종료 후 재접속시 자동 로그인
        //로그인을 성공했을 경우에만 저장시킴 -> 재접속시에는 로그인 토큰 받을 필요 없음?
        guard let id = idTextField.text else {return}
        guard let password = passwordTextField.text else{return}
        
        UserDefaults.standard.set(id, forKey: "id")
        UserDefaults.standard.set(password, forKey: "password")
    }
    
    fileprivate func getLogin(completion: @escaping (Bool, Any?, Error?) -> Void){
        //콜백 메소드 처리
        
        //TODO: login server부분 생기면 Alamofired이용해서 request보내기
    }
    
    fileprivate func loginAction(){
        //콜백 메소드
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
            USER.EMAIL = id
            self.view.endEditing(true)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.loadingView.isHidden = false
            })
            //view 전환
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                self.enterHome()
            })
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
            USER.EMAIL = id
            textField.resignFirstResponder()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.loadingView.isHidden = false
            })
            //view 전환
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                self.enterHome()
            })
            
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
        getEmailFromNaver()
        self.view.endEditing(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.loadingView.isHidden = false
        })
        //view 전환
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            self.enterHome()
        })
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

