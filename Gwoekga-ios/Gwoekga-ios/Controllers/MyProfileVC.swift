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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.profileImgView.layer.cornerRadius = 10
        self.editProfileBtn.layer.borderWidth = 1
        self.editProfileBtn.layer.borderColor = #colorLiteral(red: 1, green: 0.7959558368, blue: 0, alpha: 1)
        self.editProfileBtn.layer.cornerRadius = 10
        
        }
        
    @IBAction func onFollowingBtnClicked(_ sender: UIButton) {
        print("MyProfileVC -> onFollowingBtnClicked()")
    }
    
    @IBAction func onFollowerBtnClicked(_ sender: UIButton) {
        print("MyProfileVC -> onFollowerBtnClicked()")
    }
    
    @IBAction func onEditProfileBtnClicked(_ sender: UIButton) {
        print("MyProfileVC -> onEditProfileBtnClicked")
    }
    
}

