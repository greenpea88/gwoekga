//
//  PostVC.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/08/31.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit

class PostVC: UIViewController {

    @IBOutlet weak var submitBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        submitBtn.layer.cornerRadius = 15
    }

    //MARK: - IBAction Methods
    @IBAction func onSubmitBtnClicked(_ sender: UIButton) {
        print("AddVC -> onSubmitBtnClicked()")
        
        //submit 누를 시 이전 view로 되돌아감
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
