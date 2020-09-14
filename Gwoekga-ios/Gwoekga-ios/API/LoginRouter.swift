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
    
    case signUpAuth(email: String,code: String,pw: String,nickname: String,naver: String)
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var method: HTTPMethod {
        switch self {
        case .signUpAuth:
            return .post
        }
    }
    
    //end point
    var path: String {
        switch self {
        case .signUpAuth:
            return "user/signupGeneral"
        }
    }
    
    var parameters: [String:String]{
        switch self {
        case let .signUpAuth(email, code, pw, nickname, naver):
            return   ["email" : email, "code" : code, "pw" : pw, "nickname" : nickname, "naver" : naver]
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
//        print("PostRouter -> asURLRequest() url : \(url)")
        
        var request = URLRequest(url: url)
        request.method = method
        
        switch self {
        case .signUpAuth:
            request = try URLEncodedFormParameterEncoder().encode(parameters, into: request)
        }
        
        return request
    }
}

