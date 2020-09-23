//
//  DetailReviewVC.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/09/22.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit
import Cosmos

class DetailReviewVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var posterImgView: UIImageView!
    @IBOutlet weak var reviewerProfileImgView: UIImageView!
    @IBOutlet weak var reviewerUserNameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryGenreLabel: UILabel!
    @IBOutlet weak var starRate: CosmosView!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var commentTableView: UITableView!
    
    var review: Review!
//    var review: String!
    var comment = [Comment]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DetailReviewVC -> viewDidLoad()")
        
        commentTableView.delegate = self
        commentTableView.dataSource = self
    }
    
    //MARK: - IBAction Method
    @IBAction func onBackBtnClicked(_ sender: UIBarButtonItem) {
        print("DetailReviewVV -> onBackBtnClicked() / \(review)")
        dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - UITableViewDateSource Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentTableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        return cell
    }
}
