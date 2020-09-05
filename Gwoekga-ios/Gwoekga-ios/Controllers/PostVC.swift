//
//  PostVC.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/08/31.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit
import YPImagePicker //오픈소스 : https://github.com/Yummypets/YPImagePicker#configuration

class PostVC: KeyBoardNoti, UITextViewDelegate{
    
    //TODO: 다 채워지면 submit 버튼 활성화 + 포토뷰 추가하기 
    
    @IBOutlet weak var underStackView: UIView!
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
    @IBOutlet weak var postImgView: UIImageView!
    @IBOutlet weak var postImgViewHC: NSLayoutConstraint!
    @IBOutlet weak var imgDeleteBtn: UIButton!
    @IBOutlet weak var scrollViewHC: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var isCategorySelected = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PostVC -> viewDidLoad()")
        // Do any additional setup after loading the view.
        
        self.postImgView.layer.cornerRadius =  10
        self.imgDeleteBtn.layer.cornerRadius = imgDeleteBtn.frame.height / 2
        
        //title 입력 textfield에 포커스 주기
        self.titleTextField.becomeFirstResponder()
        
        self.reviewTextField.delegate = self
        self.reviewTextField.isEditable = true
    }

    //MARK: - IBAction Methods
    @IBAction func onCancleBtnClicked(_ sender: UIButton) {
        print("PostVC -> onCancleBtnClicked()")
        //이전 view로 되돌아감
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCategoryRadio(_ sender: UIButton) {
        //카테고리(책,영화,뮤지컬,연극) 선택 - radio button type으로
        isCategorySelected = 1
        
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
    
    @IBAction func onSubmitBtnClicked(_ sender: UIButton) {
        print("PostVC -> onSubmitBtnClicked")
        
        guard let title = titleTextField.text else {return}
        guard let review = reviewTextField.text else {return}
        
        if (title.isEmpty || review.isEmpty || isCategorySelected == 0){
            self.view.makeToast("빈칸을 모두 채워주세요.",duration: 1.0,position: .center)
        }
        else{
            //TODO: 입력 정보 서버로 보내기
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func onPhoToSelectBtnClicked(_ sender: UIButton) {
        print("PostVC -> onPhotoSelectBtnClicked()")
        
         //카메라 라이브러리 세팅
        var config = YPImagePickerConfiguration()
        config.screens = [.library, .photo]
        
        //navigation bar text color 세팅
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black ] // Title color
        UINavigationBar.appearance().tintColor = .yellow // Left. bar buttons
        config.colors.tintColor = .systemYellow // Right bar buttons (actions)
                
        //사진이 선택되었을 때
        let picker = YPImagePicker(configuration: config)
        picker.didFinishPicking { [unowned picker] items, _ in
        //선택되는 사진이 존재한다면
            if let photo = items.singlePhoto {
//                print(photo.fromCamera) // Image source (camera or library)
//                print(photo.image) // Final image selected by the user
//                print(photo.originalImage) // original image selected by the user, unfiltered
//                print(photo.modifiedImage) // Transformed image, can be nil
//                print(photo.exifMeta) // Print exif meta data of original image.
                let ratio = photo.image.size.width / photo.image.size.height
                let newHeight = self.postImgView.bounds.width * ratio
                print("new height / \(newHeight)")
                print("before height / \(self.postImgViewHC.constant)")
                self.postImgViewHC.constant = newHeight
                print("before height / \(self.postImgViewHC.constant)")
                //사진 추가
                self.postImgView.image = photo.image
                self.imgDeleteBtn.isHidden = false
            }
        //picker 창 닫기
        picker.dismiss(animated: true, completion: nil)
        }
                
        //picker 창 보여주기
        present(picker, animated: true, completion: nil)
        
    }
    
    @IBAction func onImgDeleteBtnClicked(_ sender: UIButton) {
        print("PostVC -> onImgDeleteBtnClicked()")
        self.postImgView.image = nil
        sender.isHidden = true
    }
    
    
    
    //MARK: - UITextViewDelegate Method
    func textViewDidChange(_ textView: UITextView) {
        //textfield의 placeholder로 label을 대신 사용 -> 값이 입력되면 hidden 값 이용해 없애기
        if (textView.text == ""){
            self.reviewPlaceHold.isHidden = false
        }
        else{
            
            self.reviewPlaceHold.isHidden = true
            //TODO: 하단바보다 textView height 높아지면 scorll on 하기
//
//            let underStackViewLoc = self.underStackView.frame.origin.y
////            print("underStackViewLoc  \(underStackViewLoc)")
//            let textViewTop = textView.frame.origin.y
////            print("textViewTop  \(textViewTop)")
//            let distance = underStackViewLoc - textViewTop - 10
//            print("distance \(distance)")
            //입력 값에 따라 textView 크기 동적 변경
            let size = CGSize(width: textView.frame.width, height: .infinity)
            //textView안에 텍스트들을 가지고 맞는 크기를 계산함
            let estimatedSize = textView.sizeThatFits(size)
//            print("estimatedSize / \(textView.sizeThatFits(size).height)")
//            if (distance >= estimatedSize.height){
//                //textView 높이 변경
//                print("change")
//                self.reviewTextFieldHC.constant = estimatedSize.height
//            }
//            else{
//                self.reviewTextField.isScrollEnabled = true
//            }
            self.reviewTextFieldHC.constant = estimatedSize.height
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let inputTextCount = textView.text?.appending(text).count ?? 0
        
//        print("PostVC -> textView shouldChangeTextIn() / \(inputTextCount)")
        
        if (inputTextCount<=280){
            self.textCountLabel.text = String(inputTextCount) + " / 280"
            return true
        }
        else{
            return false
        }
    }
    
    //MARK: - KeyBoardNoti override
    @objc override func keyboardWillShow(notification: NSNotification){
        print("PostVC -> keyboardWillShow()")
        //키보드 올라오는만큼 아래바 올리기
       if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
        let viewHeight = self.view.frame.height
//        print("keyboard height \(viewHeight - keyboardSize.height)")
//        print("underStackVeiw location \(self.underStackView.frame.origin.y)")
        
        if (viewHeight - keyboardSize.height < self.underStackView.frame.origin.y){
            let distance =  viewHeight -  self.underStackView.frame.origin.y - self.underStackView.frame.height
//            print("underStckVeiw location  / \(self.underStackView.frame.origin.y)")
//            print("from bottom / \(distance)")
            self.underStackView.transform = CGAffineTransform(translationX: 0, y: -keyboardSize.height + distance)
            let newHeight =
                self.underStackView.frame.origin.y - self.scrollView.frame.origin.y
            self.scrollViewHC.constant = newHeight
        }
        }

    }

    @objc override func keyboardWillHide(notification: NSNotification){
        //키보드 내려가면 원상복구
        //TODO: - 키보드 사라질 때 notification 감지 왜 못하는지?
        print("PostVC -> keyboardWillHide()")
        self.underStackView.transform = .identity
        let newHeight =
            self.underStackView.frame.origin.y - self.scrollView.frame.origin.y
        self.scrollViewHC.constant = newHeight
    }
}
