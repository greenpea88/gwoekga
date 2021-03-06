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
    @IBOutlet weak var notFitToEmailFormat: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordCheckField: UITextField!
    @IBOutlet weak var passwordNotSameLabel: UILabel!
    @IBOutlet weak var loadingActivity: UIActivityIndicatorView!
    
    var keyboardDissmissTabGesture: UIGestureRecognizer = UIGestureRecognizer(target: self, action: nil)
    
    var randomNumber: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        //상단 네비게이션 바 부분 숨김 처리
        self.navigationController?.isNavigationBarHidden = true
        joinBtn.layer.cornerRadius = joinBtn.frame.height / 2
        
        joinBtn.isEnabled = false

        self.keyboardDissmissTabGesture.delegate = self
        self.usernameTextField.delegate = self
        self.idTextField.delegate = self
        self.passwordTextField.delegate = self
        self.passwordCheckField.delegate = self

        self.view.addGestureRecognizer(keyboardDissmissTabGesture)
        
        idTextField.addTarget(self, action: #selector(textFieldDidchange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidchange(_:)), for: .editingChanged)
        passwordCheckField.addTarget(self, action: #selector(textFieldDidchange(_:)), for: .editingChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
        print("loginVC -> prepare()")
        switch segue.identifier{
        case SEGUE.CHECK_AUTH:
            let authVC = segue.destination as! CheckAuthVC
            authVC.randomNum = randomNumber
            
            guard let nickName = usernameTextField.text else {return}
            guard let email = idTextField.text else {return}
            guard let password = passwordTextField.text else {return}
            
            authVC.nickName = nickName
            authVC.email = email
            authVC.pw = password
        default:
            print("default")
        }
        }
    
    func checkEmailValid(){
        let allowNum = "0123456789"
        randomNumber = String((1..<7).map{_ in allowNum.randomElement()!})
//         LoginManager.shared.signUpAuth(email: "green_pea88@naver.com", code: randomNumber){result in
//                        debugPrint(result)
//                        switch result{
//                        case  .success(let state):
//                            if (state == "success"){
//                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//                                    self.performSegue(withIdentifier: SEGUE.CHECK_AUTH, sender: self)
//                                })
//                            }
//                            else{
//                                self.view.makeToast("이미 존재하는 이메일입니다.",duration: 1.0,position: .center)
//                            }
//                        case .failure(let error):
//                            print(error)
//                        }
//                    } //서버 문제로 인한 500 error
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.performSegue(withIdentifier: SEGUE.CHECK_AUTH, sender: self)
        })
    }
    
    //MARK: - IBAction Methods
    @IBAction func onRegisteredBtnClicked(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onJoinBtnClicked(_ sender: UIButton) {
        
        guard let username = usernameTextField.text else {return}
        guard let id = idTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let passwordCheck = passwordCheckField.text else {return}
        
        if (username.isEmpty || id.isEmpty || password.isEmpty || passwordCheck.isEmpty){
            self.view.makeToast("회원 정보를 모두 입력해주세요.",duration: 1.0,position: .center)
        }
        else{
            //키보드 내리기
            self.view.endEditing(true)
            USER.EMAIL = id
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//                self.performSegue(withIdentifier: SEGUE.CHECK_AUTH, sender: self)
//            })
            checkEmailValid()
        }
    }
    
    //MARK:- objc
    @objc func textFieldDidchange(_ textField: UITextField){
        print("JoinVC -> textFiledDidChange()")
        if (textField.tag == 2){
            guard let inputText = textField.text else {return}
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,20}"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
            
            if (emailTest.evaluate(with: inputText)) {
                notFitToEmailFormat.isHidden = true
            }
                else{
                notFitToEmailFormat.isHidden = false
            }
        }
        else if (textField.tag == 3){
            guard let inputText = textField.text else {return}
            
            if inputText.isEmpty {
                self.passwordCheckField.isEnabled = false
            }
            else {
                self.passwordCheckField.isEnabled = true
            }
        }
        else if (textField.tag == 4){
            guard let pwCheck = textField.text else {return}
            guard let pw = passwordTextField.text else {return}
            
            if pw != pwCheck{
                self.passwordNotSameLabel.isHidden = false
                self.joinBtn.isEnabled = false
            }
            else{
                self.passwordNotSameLabel.isHidden = true
                self.joinBtn.isEnabled = true
            }
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
        guard let passwordCheck = passwordCheckField.text else {return false}
        
        if (username.isEmpty || id.isEmpty || password.isEmpty || passwordCheck.isEmpty){
            self.view.makeToast("회원 정보를 모두 입력해주세요.",duration: 1.0,position: .center)
            return false
        }
        else{
            textField.resignFirstResponder()
            USER.EMAIL = id
            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
//                self.performSegue(withIdentifier: SEGUE.CHECK_AUTH, sender: self)
//            })
            checkEmailValid()
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
