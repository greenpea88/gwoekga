//
//  EditProfile.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/09/10.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit

class EditProfileVC: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    //MARK: - IBAction Method
    @IBAction func onCancleBtnClicked(_ sender: UIBarButtonItem) {
        print("EditProfileVC -> onCancleBtnClicked")
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSubmitBtnClicked(_ sender: UIBarButtonItem) {
        print("EditProFileVC -> onSubmitBtnClicked")
    }
}
