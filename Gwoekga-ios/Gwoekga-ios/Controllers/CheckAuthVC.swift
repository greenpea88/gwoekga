//
//  CheckAuthVC.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/09/14.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit

class CheckAuthVC: KeyBoardNoti{
    
    @IBOutlet weak var authNumTextField: UITextField!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var welcome: UIView!
    
    var sendReviews = [Review]()
    var randomNum:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkBtn.layer.cornerRadius = self.checkBtn.frame.height / 2
        self.popUpView.layer.cornerRadius = 20
        
        print("randomNum : \(randomNum)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case SEGUE.JOIN_ENTER_HOHE:
            let tabBarController = segue.destination as! CustomTabBarController
            let login = tabBarController.viewControllers?[0] as! HomeVC

            login.showReviews = self.sendReviews
//            login.fromMainVeiw = 1
        default:
            print("default")
        }
    }
    
    
    //MARK: - IBAction Method
    @IBAction func onCheckBtnClicked(_ sender: UIButton) {
        print("CheckAuthVC -> onCheckBtnClicked()")
        guard let inputNum = authNumTextField.text else {return}
        
        if inputNum != randomNum{
            self.view.makeToast("인증번호가 일치하지 않습니다.",duration: 1.0,position: .center)
        }
        else{
            self.view.endEditing(true)
//            키보드 내려간 후 딜레이 주고 welcome 화면 띄우기
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.welcome.isHidden = false
            })

//            view 전환
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                self.enterHome()
            })
        }
    }
    
    //MARK: - Fileprivate Method
    fileprivate func enterHome(){
                //처음 화면이 로드될 때 불러와있을 정보들 -> 올라가있는 정보들 중 한 10개 정도만,,,?(최근 것부터~)
            let semaphore = DispatchSemaphore(value: 0)
            let loadingQueue = DispatchQueue.global()
            
            let now = Date()
            let formatter = DateFormatter()
    //        formatter.timeZone = TimeZone.current
            formatter.dateFormat = "yyyy.MM.dd HH:mm:ss"
            let dateString = formatter.string(from: now)
                
                loadingQueue.async {
                    PostManager.shared.getPost(time: dateString, completion: {[weak self] result in
                               guard let self = self else {return}
                               
                               switch result{
                               case .success(let reviews):
                                   self.sendReviews = reviews
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
    
    //MARK: - KeyBoardNoti override
       @objc override func keyboardWillShow(notification: NSNotification){
                //키보드가 버튼 가리는만큼 화면 올리기
               print("JoinVC -> keyboardWillShow()")
                
               //키보드 사이즈 가져오기
               if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
                   let screenHight = UIScreen.main.bounds.height
                   if(screenHight < keyboardSize.height + checkBtn.frame.origin.y + checkBtn.frame.height){
                                //키보드가 버튼을 덮음
                       let distance = screenHight - keyboardSize.height - checkBtn.frame.origin.y - checkBtn.frame.height
                       self.view.frame.origin.y = distance - 10
                   }
               }
            }
        
        @objc override func keyboardWillHide(notification: NSNotification){

                print("JoinVC -> keyboardWillHide()")
                
                self.view.frame.origin.y = 0

            }
}
