//
//  BaseInterceptor.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/09/07.
//  Copyright © 2020 minchae. All rights reserved.
//

import Foundation
import Alamofire

class PostInterceptor: RequestInterceptor{

    //api를 호출할 때(request할 때) 호출되는 부분
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("PostInterceptor -> adpat()")
    
        var request = urlRequest
        //header 추가
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json; charset=UTF-8", forHTTPHeaderField: "Accept")
    
        //completion을 호출하지 않으면 멈춰있게됨
        completion(.success(request))
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("PostInterceptor -> retry()")
    
        guard let statusCode = request.response?.statusCode else {
            completion(.doNotRetry)
            return
        }
    
        let data = ["statusCode" : statusCode]
    
      NotificationCenter.default.post(name: NSNotification.Name(rawValue: NOTIFICATION.API.LOAD_DATA_FAIL), object: nil, userInfo: data)
    
        //호출이 정상적으로 작동하지 않을 경우 handling
        completion(.doNotRetry)
    }
}
