//
//  PostVC.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/08/31.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit
import YPImagePicker //오픈소스 : https://github.com/Yummypets/YPImagePicker#configuration
import Alamofire
import SwiftyJSON
import Cosmos //https://github.com/evgenyneu/Cosmos

class PostVC: KeyBoardNoti, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate{
    
    
    
    //TODO: 다 채워지면 submit 버튼 활성화 + 포토뷰 추가하기 
    
    @IBOutlet weak var underStackView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var reviewTextField: UITextView!
    @IBOutlet weak var reviewTextFieldHC: NSLayoutConstraint!
    @IBOutlet weak var reviewPlaceHold: UILabel!
    @IBOutlet weak var textCountLabel: UILabel!
    @IBOutlet weak var postImgView: UIImageView!
    @IBOutlet weak var postImgViewHC: NSLayoutConstraint!
    @IBOutlet weak var imgDeleteBtn: UIButton!
    @IBOutlet weak var scrollViewHC: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var categorySelect: UITextField!
    @IBOutlet weak var genreSelect: UITextField!
    @IBOutlet weak var starRating: CosmosView!
    
    var selectTextView = 2
    var isCategorySelected = 0 //category,genre가 모두 채워졌는지 확인 -> category를 선택해야 genre를 선택하므로 genre 선택될 때 on
    var selectedCategory = ""
    var selectCategoryList = [String]() //select할 카테고리의 값이 존재
    var selectGenreList = ["카테고리를 먼저 선택해주세요"]
    var selectedGenreIdx = "" //genre값 idx로 post하므로 idx값 저장해두기
    var prevSelectCategory: String = ""
    
    var selectCategoryGenre: UIGestureRecognizer = UIGestureRecognizer(target: self, action: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("PostVC -> viewDidLoad()")
        // Do any additional setup after loading the view.
        
        self.postImgView.layer.cornerRadius =  10
        self.imgDeleteBtn.layer.cornerRadius = imgDeleteBtn.frame.height / 2
        
        self.reviewTextField.delegate = self
        self.selectCategoryGenre.delegate = self
        self.reviewTextField.isEditable = true
        
        self.view.addGestureRecognizer(selectCategoryGenre)
        
        requestCategory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //인증 실패 노티피케이션 등록
        NotificationCenter.default.addObserver(self, selector: #selector(showErrorPopUP(notification:)), name: NSNotification.Name(rawValue: NOTIFICATION.API.LOAD_DATA_FAIL), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATION.API.LOAD_DATA_FAIL), object: nil)
    }

    //MARK: - IBAction Methods
    @IBAction func onCancleBtnClicked(_ sender: UIButton) {
        print("PostVC -> onCancleBtnClicked()")
        //이전 view로 되돌아감
        self.dismiss(animated: true, completion: nil)
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
            postReview()
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
//                print("new height / \(newHeight)")
//                print("before height / \(self.postImgViewHC.constant)")
                self.postImgViewHC.constant = newHeight
//                print("before height / \(self.postImgViewHC.constant)")
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
        self.postImgViewHC.constant = 0
        sender.isHidden = true
    }

    @IBAction func onDonBtnClicked(_ sender: Any){
        self.view.endEditing(true)
    }
    
    //MARK: - UITextViewDelegate Method
    func textViewDidChange(_ textView: UITextView) {
        //textfield의 placeholder로 label을 대신 사용 -> 값이 입력되면 hidden 값 이용해 없애기
        if (textView.text == ""){
            self.reviewPlaceHold.isHidden = false
        }
        else{
            
            self.reviewPlaceHold.isHidden = true
            let size = CGSize(width: textView.frame.width, height: .infinity)
            //textView안에 텍스트들을 가지고 맞는 크기를 계산함
            let estimatedSize = textView.sizeThatFits(size)
            //텍스트 필드 높이 재정의하기
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

    //MARK: - PickerViewDataSouce Method
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        //하나의 PickerView에서 선택 가능한 리스트의 수
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //PickerView에 표시될 항목의 개수를 반환
        switch selectTextView{
        case 0:
            return selectCategoryList.count
        case 1:
            return selectGenreList.count
        default:
            return selectCategoryList.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //PickerView 내에서 특정한 위치(row)를 가리키게 될 때, 그 위치에 해당하는 문자열을 반환
//        return selectCategoryList[row]
        switch selectTextView{
        case 0:
            return selectCategoryList[row]
        case 1:
            return selectGenreList[row]
        default:
            return selectCategoryList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //PickerView 에서 특정 row가 focus되었을 때 어떤 행동을 할지 정의
        switch selectTextView{
        case 0:
            categorySelect.text = selectCategoryList[row]
            requestGenre(selectCategoryList[row])
        case 1:
            isCategorySelected = 1
            selectedGenreIdx = "[" + String(row+1) + "]"
            genreSelect.text = selectGenreList[row]
        default:
            categorySelect.text = selectCategoryList[row]
        }
    }
    
    //MARK: - UIGestureRecognizerDelegate Method
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        //사용자가 터치했을 때 동작하게 됨
        
        if (touch.view?.isDescendant(of: categorySelect) == true){
            print("PostVC -> gesture category")
            selectTextView = 0
//            print(selectList)
            self.createPickerView(self.categorySelect)
            self.dismissPickerView()
            return true
        }
        else if(touch.view?.isDescendant(of: genreSelect) == true){
            print("PostVC -> gesture genre")
            selectTextView = 1
            createPickerView(genreSelect)
            dismissPickerView()
            if (selectGenreList.count == 0){
                
                self.view.makeToast("선택할 수 있는 장르가 없습니다.😥", duration: 1.0, position: .center)
            }
            return true
        }
        else{
            //키보드 내림
            return false
        }
    }
    
    //MARK: - pickerView display
    func createPickerView(_ textField: UITextField){
        print("PostVC -> createPickerView")
        let displayPickerView = UIPickerView()
        displayPickerView.delegate = self

        textField.inputView = displayPickerView
    }
    
    func dismissPickerView(){
        print("PostVC -> dismissPickerView()")
        let toolBar = UIToolbar()
//        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        //constraint 충돌 방지 위해 위에 것 대신 해당 방식으로 선언해도 됨
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.onDonBtnClicked(_:)))
        toolBar.items =  [button]
        toolBar.tintColor = #colorLiteral(red: 1, green: 0.7959558368, blue: 0, alpha: 1)
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        toolBar.updateConstraintsIfNeeded() //constraint error 해결위해 추가

        switch selectTextView{
        case 0:
            categorySelect.inputAccessoryView = toolBar
        case 1:
            genreSelect.inputAccessoryView = toolBar
        default:
            categorySelect.inputAccessoryView = toolBar
        }
    }
    
    //MARK: - KeyBoardNoti override
    @objc override func keyboardWillShow(notification: NSNotification){
        print("PostVC -> keyboardWillShow()")
        
        self.underStackView.transform = .identity
        
        //키보드 올라오는만큼 아래바 올리기
       if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
        let viewHeight = self.view.frame.height
//        print("keyboard height \(viewHeight - keyboardSize.height)")
//        print("underStackVeiw location \(self.underStackView.frame.origin.y)")
        
        if (viewHeight - keyboardSize.height < self.underStackView.frame.origin.y){
            //만약에 키보드보다 아래에 있다면
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
    
    //MARK: - HTTP request
    func requestCategory(){
        
        PostManager.shared.getCategory(completion: {[weak self] result in
            guard let self = self else {return}
            
            switch result{
            case .success(let categories):
                self.selectCategoryList = categories
            case .failure(let error):
                print("error : \(error)")
            }
        })
    }
    
    func requestGenre(_ category: String){
        //선택한 장르와 다르면 배열 초기화
        if selectedCategory != category{
            self.selectGenreList = []
            PostManager.shared.getGenre(category: category, completion: {[weak self] result in
                guard let self = self else {return}
                
                switch result{
                case .success(let genres):
                    self.selectGenreList = genres
                case .failure(let error):
                    print("error : \(error)")
                }
            })
        }
        
        selectedCategory = category
    }
    
    func postReview(){
        guard let title = titleTextField.text else {return}
        guard let review = reviewTextField.text else {return}
        let rate = Float(starRating.rating)
        guard let category = categorySelect.text else {return}
        print("PostVC -> postReview() / title \(title), review \(review), rate \(rate), category \(category), genre \(selectedGenreIdx)")
        
        let posting = Review(title: title,written: review, star: rate, email: USER.EMAIL, category: category, genres: selectedGenreIdx)
        
        PostManager.shared.postPost(review: posting, completion: { result in
            debugPrint(result)
        })
    }
    
    //MARK: - objc Methods
    @objc func showErrorPopUP(notification: NSNotification){
        print("BaseVC -> showErrorPopUp()")
        
        if let data = notification.userInfo?["statusCode"]{
            print("showErrorPopUp() \(data)")
            
//            DispatchQueue.main.async {
//                //view에 관련된 사항은 main thread에서 진행해줘야함
//                self.view.makeToast("데이터를 로드할 수 없습니다.", duration: 1.0, position: .center)
//            }
        }
    }
}

