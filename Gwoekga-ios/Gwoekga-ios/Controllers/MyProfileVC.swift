//
//  MyProfileVC.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/09/01.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit
import Alamofire

class MyProfileVC: UIViewController {
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var followingNumBtn: UIButton!
    @IBOutlet weak var followerNumBtn: UIButton!
    @IBOutlet weak var editProfileBtn: UIButton!
    
    var clickedBtn = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.profileImgView.layer.cornerRadius = 10
        self.editProfileBtn.layer.borderWidth = 1
        self.editProfileBtn.layer.borderColor = #colorLiteral(red: 1, green: 0.7959558368, blue: 0, alpha: 1)
        self.editProfileBtn.layer.cornerRadius = 10
        
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
        default:
            print("defualt")
        }
    }
        
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
    
}

