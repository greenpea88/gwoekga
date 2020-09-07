//
//  CommunicationManager.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/09/07.
//  Copyright © 2020 minchae. All rights reserved.
//

import Foundation
import Alamofire

final class CommunicationManager{
    
    //singleton pattern
    static let shared = CommunicationManager()
    
    //인터셉터
//    let interceptors = Interceptor(interceptors:
//                        [
//                            BaseInterceptor()
//                        ])
    
    //이벤트 모니터
//    let monitor = [MyLogger()] as [EventMonitor]
    
    //session
//    var session : Session
//    
//    private init(){
//        session = Session(interceptor: interceptors, eventMonitors: monitor)
//    }
}
