//
//  KeyBoardNoti.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/09/03.
//  Copyright © 2020 minchae. All rights reserved.
//

import UIKit

class KeyBoardNoti: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        //키보드가 올라가고 내려가고는 iphone에서 default로 notification을 보내줌
        //notification center 설치
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
       }
    
    //MARK: - @objc
    @objc func keyboardWillShow(notification: NSNotification){
    }

    @objc func keyboardWillHide(notification: NSNotification){
        
    }
}


