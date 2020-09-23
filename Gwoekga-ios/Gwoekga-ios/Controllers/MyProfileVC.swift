//
//  MyProfileVC.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/09/01.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit
import Alamofire

class MyProfileVC: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var followingNumBtn: UIButton!
    @IBOutlet weak var followerNumBtn: UIButton!
    @IBOutlet weak var editProfileBtn: UIButton!
    @IBOutlet weak var reviewTableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var clickedBtn = ""
//    var myReview = [Review]()
    var myReview = ["1","2","3"]
//    var clickedReivew: Review!
    var clickedReview: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.profileImgView.layer.cornerRadius = 10
        self.editProfileBtn.layer.borderWidth = 1
        self.editProfileBtn.layer.borderColor = #colorLiteral(red: 1, green: 0.7959558368, blue: 0, alpha: 1)
        self.editProfileBtn.layer.cornerRadius = 10
        
        reviewTableView.delegate = self
        reviewTableView.dataSource = self
        
        reviewTableView.refreshControl  = UIRefreshControl()
        reviewTableView.refreshControl?.addTarget(self,action: #selector(pullToRefresh),for: .valueChanged)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case SEGUE.FOLLOW:
            let navi = segue.destination as! FollowNaviVC
            if (clickedBtn == "following") {
                let following = navi.topViewController as! FollowVC
                following.selectedIndex = 0
                following.selectedIdxPath = IndexPath(item: 0, section: 0)
            }
            else if (clickedBtn == "follower"){
                let follower = navi.topViewController as! FollowVC
                follower.selectedIndex = 1
                follower.selectedIdxPath = IndexPath(item: 1, section: 0)
            }
        case SEGUE.DETAIL_REVIEW:
            let navi = segue.destination as! ReviewNaviVC
            let detailReview = navi.topViewController as! DetailReviewVC
            detailReview.review  = clickedReview
        default:
            print("defualt")
        }
    }
    
    func loadNewPost(){
        print("MyProfileVC -> loadNewPost()")
    }
    
    func loadPastPost(){
        print("MyProfileVC -> loadPastPost()")
        self.loadingIndicator.isHidden = true
    }
    
    //MARK: - IBAction Method
    @IBAction func onFollowingBtnClicked(_ sender: UIButton) {
        print("MyProfileVC -> onFollowingBtnClicked()")
        clickedBtn = "following"
        self.performSegue(withIdentifier: SEGUE.FOLLOW, sender: self)
    }
    
    @IBAction func onFollowerBtnClicked(_ sender: UIButton) {
        print("MyProfileVC -> onFollowerBtnClicked()")
        clickedBtn = "follower"
        self.performSegue(withIdentifier: SEGUE.FOLLOW, sender: self)
    }
    
    @IBAction func onEditProfileBtnClicked(_ sender: UIButton) {
        print("MyProfileVC -> onEditProfileBtnClicked")
    }
    
    //MARK: - objc
    @objc func pullToRefresh(_ sender: Any) {
        // 새로고침 시 갱신되어야할 내용
        print("HomeVC -> pullToRefresh()")
        loadNewPost()
        self.reviewTableView.reloadData()
        // 당겨서 새로고침 종료
        reviewTableView.refreshControl?.endRefreshing()
    }
    
    //MARK: - UITabelViewDataSource Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myReview.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = reviewTableView.dequeueReusableCell(withIdentifier: "simplePostInfo", for: indexPath) as! SimpleInfoCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //클릭한 review 정보 받아오기
        clickedReview = myReview[indexPath.row]
        self.performSegue(withIdentifier: SEGUE.DETAIL_REVIEW, sender: self)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //제일 밑까지 내려가면 이전 정보 불러오기
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if maximumOffset - currentOffset <= 10.0 {
            print("end of scroll")
            DispatchQueue.main.async {
                self.loadingIndicator.isHidden = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                self.loadPastPost()
            })
        }
    }
}

