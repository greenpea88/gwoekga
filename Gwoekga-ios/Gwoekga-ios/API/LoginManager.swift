//
//  LoginManager.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/09/10.
//  Copyright © 2020 minchae. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class LoginManager{
    
    //singleton pattern
    static let shared = LoginManager()
    
    //인터셉터
    let interceptors = Interceptor(interceptors:
                        [
                            PostInterceptor()
                        ])
    
    //이벤트 모니터
//    let monitor = [MyLogger()] as [EventMonitor]
    
    //session
    var session : Session
    
    private init(){
        session = Session(interceptor: interceptors)
    }
    
//    func signUpAuth(email: String, code: String, pw: String, nickname: String, naver: String){
//        //completion 추가하기
//        self.session
//            .request(LoginRouter.signUpAuth(email: email, code: code)
//            .validate(statusCode: 200..<400)
//            .responseJSON(completionHandler: { response in
//            debugPrint(response)
//        })
//    }
}
