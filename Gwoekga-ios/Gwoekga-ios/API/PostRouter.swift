//
//  PostRouter.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/09/07.
//  Copyright © 2020 minchae. All rights reserved.
//

import Foundation
import Alamofire

enum PostRouter: URLRequestConvertible {
    case getCategoryList
    case getGenreList(term: String)
    case postPost(post: Review) //body에 데이터 넣어서 보내기
    case getPost
    
    var baseURL: URL {
        return URL(string: API.BASE_URL)!
    }
    
    var method: HTTPMethod {
        switch self {
        case .getCategoryList, .getGenreList:
            return .get
        case .postPost:
            return .post
        case .getPost:
            return .post
        }
    }
    
    //end point
    var path: String {
        switch self {
        case .getCategoryList:
            return "category/all"
        case let .getGenreList(term):
            return "category/" + term
        case .postPost:
            return "post/upload"
        case .getPost:
            return "post/all" //test용
        }
    }
    
    
    func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        
//        print("PostRouter -> asURLRequest() url : \(url)")
        
        var request = URLRequest(url: url)
        request.method = method
        
        switch self {
        case .getCategoryList, .getGenreList:
            break
        case let .postPost(post):
//            print(post)
            let body = ["title" : post.title, "written" : post.written, "star" : String(post.star), "email" : post.email, "category" : post.category, "genres" : post.genres]
//            request.httpBody = try JSONSerialization.data(withJSONObject: body,options: [])
//            request.httpBody = body
            request = try URLEncodedFormParameterEncoder().encode(body,into: request)
        case .getPost:
            break
        }
        
        return request
    }
}
