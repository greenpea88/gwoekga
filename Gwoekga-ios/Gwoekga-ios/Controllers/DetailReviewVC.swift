//
//  DetailReviewVC.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/09/22.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit
import Cosmos
import Toast_Swift

class DetailReviewVC: KeyBoardNoti, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var posterImgView: UIImageView!
    @IBOutlet weak var reviewerProfileImgView: UIImageView!
    @IBOutlet weak var reviewerUserNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryGenreLabel: UILabel!
    @IBOutlet weak var starRate: CosmosView!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var commentTableView: UITableView!
    @IBOutlet weak var insertCommentStackView: UIStackView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentSubmitBtn: UIButton!
    
    var review: Review!
//    var review: String!
    var comment = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DetailReviewVC -> viewDidLoad()")
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
        commentTextField.delegate = self
        
        commentTextField.becomeFirstResponder()
    }
    
    //MARK: - IBAction Method
    @IBAction func onBackBtnClicked(_ sender: UIBarButtonItem) {
        print("DetailReviewVC -> onBackBtnClicked()")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onCommentSubmitBtnClicked(_ sender: UIButton) {
        print("DetailReviewVC  -> onCommentSubmitBtnClicked")
        guard let comment = commentTextField.text else {return}
        
        if comment.isEmpty{
            self.view.makeToast("Comment를 입력해주세요.",duration: 1.0,position: .center)
        }
//        else{
//            //서버에 값 전송하기
//        }
    }
    
    
    
    //MARK: - UITableViewDateSource Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentTableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        return cell
    }
    
    //MARK: - UITextFieldDelegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let comment = textField.text else {return false}
        
        if comment.isEmpty{
            self.view.makeToast("Comment를 입력해주세요.",duration: 1.0,position: .center)
            return false
        }
        else{
            //comment 정보 서버에 전송하기
            return true
        }
        
    }
    
    //MARK: - KeyBoardNoti Override
    @objc override func keyboardWillShow(notification: NSNotification){
            //키보드가 버튼 가리는만큼 화면 올리기
            print("DetailReviewVC -> keyboardWillShow()")

            //키보드 사이즈 가져오기
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
                let viewHeight = self.view.frame.height
                        
                if (viewHeight - keyboardSize.height < self.insertCommentStackView.frame.origin.y){
                    //만약에 키보드보다 아래에 있다면
                    let distance =  viewHeight -  self.insertCommentStackView.frame.origin.y - self.insertCommentStackView.frame.height
                    self.view.frame.origin.y = distance - 10
                }
            }
        }
    
    @objc override func keyboardWillHide(notification: NSNotification){
            print("DetailReviewVC -> keyboardWillHide()")
            self.view.frame.origin.y = 0
        }
}
