//
//  Constants.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/09/07.
//  Copyright © 2020 minchae. All rights reserved.
//

import Foundation

enum API{
    static let BASE_URL = "http://ec2-54-237-170-211.compute-1.amazonaws.com:8080/api/"
}

enum NOTIFICATION{
    enum API{
        static let AUTH_FAIL = "authentication failed"
        static let LOAD_DATA_FAIL = "data load failed"
    }
}
