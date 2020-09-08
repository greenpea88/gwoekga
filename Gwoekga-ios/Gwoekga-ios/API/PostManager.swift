//
//  CommunicationManager.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/09/07.
//  Copyright © 2020 minchae. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class PostManager{
    
    //singleton pattern
    static let shared = PostManager()
    
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
    
    func getCategory(completion: @escaping (Result<[String], MyError>) -> Void){
        
        print("PostManager -> getCategory()")
        
        self.session
            .request(PostRouter.getCategoryList)
            .validate(statusCode: 200..<400).responseJSON(completionHandler: {response in
                guard let responseValue = response.value else {return}
                
//                debugPrint(response)
                var categories = [String]()
                let jsonArray = JSON(responseValue)
                
                
                print("jsonArray.count \(jsonArray.count)")
                
                for (index, subJson): (String, JSON) in jsonArray{
                    print("index : \(index) subJson : \(subJson)")
                    
                    //데이터 파싱
                    let category = subJson["categoryEng"].stringValue
                    //배열에 넣고
                    categories.append(category)
                }
                print(categories)
                if categories.count > 0 {
                    completion(.success(categories))
                }
                else{
                    completion(.failure(.noContent))
                }
        })
    }
    
    func getGenre(category: String,completion: @escaping (Result<[String], MyError>) -> Void){
        print("PostManager -> getGenre()")
        
        self.session
            .request(PostRouter.getGenreList(term: category))
            .validate(statusCode: 200..<400).responseJSON(completionHandler: { response in
                guard let responseValue = response.value else { return }
                
                var genres = [String]()
                let jsonArray = JSON(responseValue)
                
                for (index, subJson): (String, JSON) in jsonArray{
                    
                    let genre = subJson["genreEng"].stringValue
                    genres.append(genre)
                }
                print(genres)
                if genres.count > 0 {
                    completion(.success(genres))
                }
                else{
                    completion(.failure(.noContent))
                }
            })
    }
    
    func postPost(review: Review,completion: @escaping (Result<[String], MyError>) -> Void){
      
        print("PostManager -> postGenre()")
        
        self.session
            .request(PostRouter.postPost(post: review))
            .responseJSON(completionHandler: {  response in
            debugPrint(response)
        })
      }
}
