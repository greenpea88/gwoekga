//
//  LoginRouter.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/09/10.
//  Copyright © 2020 minchae. All rights reserved.
//

import Foundation
import Alamofire

enum LoginRouter: URLRequestConvertible {
    
    case signUpAuth(email: String,code: String)
    case signUp(email: String,pw: String,nickname: String,naver: String)
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUpAuth:
            return .post
        case .signUp:
            return .post
        }
    }
    
    //end point
    var path: String {
        switch self {
        case .signUpAuth:
            return "user/sendEmail"
        case  .signUp:
            return "user/signup"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
//        print("PostRouter -> asURLRequest() url : \(url)")
        
        var request = URLRequest(url: url)
        request.method = method
        
        switch self {
        case let .signUpAuth(email,code):
             let body = ["email" : email, "code" : code]
             request = try URLEncodedFormParameterEncoder().encode(body,into: request)
        case let .signUp(email, pw, nickname, naver):
            let body = ["email" : email, "pw" : pw, "nickname" : nickname, "naver" : naver]
            request = try URLEncodedFormParameterEncoder().encode(body,into :request)
        }
        
        return request
    }
}

