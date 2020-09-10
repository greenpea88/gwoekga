//
//  JoinVC.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/08/31.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit
import Toast_Swift // 오픈소스 : https://github.com/scalessec/Toast-Swift

class JoinVC: KeyBoardNoti, UIGestureRecognizerDelegate,UITextFieldDelegate {
    
    //TODO: 입력된 정보가 이미 가입된 회원인지 확인(id값으로 확인/username은 중복 사용 가능)
    //회원가입한 경우 = 로그인 바로 다음화면으로 넘어가기
    
    @IBOutlet weak var joinBtn: UIButton!
    @IBOutlet weak var joinInfoField: UIStackView!
    @IBOutlet weak var registeredBtn: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var welcomeView: UIView!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    var loadedReviews = [Review]()
    var sendReviews = [Review]()
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
    //        print("loginVC -> prepare() \(self.sendReviews)")
            switch segue.identifier {
            case SEGUE.JOIN_ENTER_HOHE:
                let tabBarController = segue.destination as! CustomTabBarController
                let login = tabBarController.viewControllers?[0] as! HomeVC
                
                login.showReviews = self.sendReviews
                login.fromMainVeiw  = 1
            default:
                print("default")
            }
        }
    
    fileprivate func enterHome(){
            //처음 화면이 로드될 때 불러와있을 정보들 -> 올라가있는 정보들 중 한 10개 정도만,,,?(최근 것부터~)
        loadingActivity.isHidden = false
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
                //화면 전환 방법 segue로 변경
                self.performSegue(withIdentifier: SEGUE.JOIN_ENTER_HOHE, sender: self)
            }
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
            USER.EMAIL = id
            //키보드 내려간 후 딜레이 주고 welcome 화면 띄우기
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.welcomeView.isHidden = false
            })
            
            //view 전환
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                self.enterHome()
            })
        }
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
            USER.EMAIL = id
            //키보드 내려간 후 딜레이 주고 welcome 화면 띄우기
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.welcomeView.isHidden = false
            })
            
            //view 전환
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                self.enterHome()
            })
            return true
        }

    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.tag == 1){
            
            
            let inputTextCount = textField.text?.appending(string).count ?? 0
            
            if (inputTextCount > 8){
                self.view.makeToast("🚨8자 이하로 입력해주세요🚨", duration: 1.0, position: .center)
                return false
            }
            else{
                return true
            }
        }
        else{
            return true
        }
    }
    
    //MARK: - KeyBoardNoti override
    @objc override func keyboardWillShow(notification: NSNotification){
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
     
     @objc override func keyboardWillHide(notification: NSNotification){

             print("JoinVC -> keyboardWillHide()")
             
             self.view.frame.origin.y = 0

         }
}
