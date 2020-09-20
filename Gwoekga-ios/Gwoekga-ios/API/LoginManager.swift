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
    
    func signUpAuth(email: String, code: String, completion: @escaping (Result<String, MyError>) -> Void){
        //completion 추가하기
        self.session
            .request(LoginRouter.signUpAuth(email: email, code: code))
            .validate(statusCode: 200..<400)
            .responseJSON(completionHandler: { response in
                guard let responseValue = response.value else {return}
                let jsonArray = JSON(responseValue)
                
                let success = jsonArray["state"].stringValue
                
                if (success == "success"){
                    completion(.success("success"))
                }
                else{
                    completion(.failure(.cantSendEmail))
                }
        })
    }
    
    func signUp(email: String, pw: String, nickName: String, naver: String, completion: @escaping (Result<String, MyError>) -> Void){
        self.session
            .request(LoginRouter.signUp(email: email, pw: pw, nickname: nickName, naver: naver))
            .validate(statusCode: 200..<400)
            .responseJSON(completionHandler: {response in
            debugPrint(response)
                guard let responseValue = response.value else {return}
                let jsonArray = JSON(responseValue)
                
                let result = jsonArray["status"].stringValue
                
                if(result == "성공"){
                    completion(.success("success"))
                }
                else{
                    completion(.failure(.cantAddUser))
                }
        })
    }
}
