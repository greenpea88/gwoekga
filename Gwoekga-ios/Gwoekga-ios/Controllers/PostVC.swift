//
//  PostVC.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/08/31.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit

class PostVC: UIViewController, UITextViewDelegate{
    
    //TODO: 글자수 제한 걸기 + 다 채워지면 submit 버튼 활성화 + 포토뷰 추가하기 
    
    @IBOutlet weak var underStackView: UIStackView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var bookBtn: UIButton!
    @IBOutlet weak var movieBtn: UIButton!
    @IBOutlet weak var musicalBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var reviewTextField: UITextView!
    @IBOutlet weak var reviewTextFieldHC: NSLayoutConstraint!
    @IBOutlet weak var reviewPlaceHold: UILabel!
    @IBOutlet weak var textCountLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PostVC -> viewDidLoad()")
        // Do any additional setup after loading the view.
        
        //title 입력 textfield에 포커스 주기
        self.titleTextField.becomeFirstResponder()
        
        self.reviewTextField.delegate = self
        self.reviewTextField.isEditable = true
        
        //입력값 없을 때 버튼 비활성화
        submitBtn.isUserInteractionEnabled = false
        //Color Literal 사용해서 custom색 지정
        submitBtn.setTitleColor(#colorLiteral(red: 1, green: 0.8960878849, blue: 0.6251387, alpha: 1), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("PostVC  -> viewWillAppear()")
        //키보드가 올라가고 내려가고는 iphone에서 default로 notification을 보내줌
        //notification center 설치
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        print("PostVC -> viewWillDisappear()")
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    //MARK: - IBAction Methods
    @IBAction func onCancleBtnClicked(_ sender: UIButton) {
        print("PostVC -> onCancleBtnClicked()")
        //이전 view로 되돌아감
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCategoryRadio(_ sender: UIButton) {
        //카테고리(책,영화,뮤지컬,연극) 선택 - radio button type으로
        
        if (sender.tag == 1){
            bookBtn.isSelected = true
            movieBtn.isSelected = false
            musicalBtn.isSelected = false
            playBtn.isSelected = false
        }
        else if (sender.tag == 2){
            bookBtn.isSelected = false
            movieBtn.isSelected = true
            musicalBtn.isSelected = false
            playBtn.isSelected = false
        }
        else if (sender.tag == 3){
            bookBtn.isSelected = false
            movieBtn.isSelected = false
            musicalBtn.isSelected = true
            playBtn.isSelected = false
        }
        else if (sender.tag == 4){
            bookBtn.isSelected = false
            movieBtn.isSelected = false
            musicalBtn.isSelected = false
            playBtn.isSelected = true
        }
    }
    
    //MARK: - @objc
    @objc func keyboardWillShow(notification: NSNotification){
        print("PostVC -> keyboardWillShow()")
        //키보드 올라오는만큼 아래바 올리기
       if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
        self.underStackView.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height)
        }
        
    }

    @objc func keyboardWillHide(notification: NSNotification){
        //키보드 내려가면 원상복구
        //TODO: - 키보드 사라질 때 notification 감지 왜 못하는지?
        print("PostVC -> keyboardWillHide()")
        self.underStackView.transform = .identity

    }
    
    //MARK: - UITextViewDelegate Method
    func textViewDidChange(_ textView: UITextView) {
        //textfield의 placeholder로 label을 대신 사용 -> 값이 입력되면 hidden 값 이용해 없애기
        if (textView.text == ""){
            self.reviewPlaceHold.isHidden = false
        }
        else{
            self.reviewPlaceHold.isHidden = true
        
            //입력 값에 따라 textView 크기 동적 변경
            let size = CGSize(width: textView.frame.width, height: .infinity)
            //textView안에 텍스트들을 가지고 맞는 크기를 계산함
            let estimatedSize = textView.sizeThatFits(size)
            //textView 높이 변경
            self.reviewTextFieldHC.constant = estimatedSize.height
           
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let inputTextCount = textView.text?.appending(text).count ?? 0
        
        print("PostVC -> textView shouldChangeTextIn() / \(inputTextCount)")
        
        if (inputTextCount<=280){
            self.textCountLabel.text = String(inputTextCount) + " / 280"
            return true
        }
        else{
            return false
        }
    }
    
}
