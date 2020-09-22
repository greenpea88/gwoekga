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
        static let JOIN_ACCESS_FAIL = "join failed"
    }
}

enum USER{
    static var USERNAME: String = ""
    static var EMAIL: String = ""
}

enum SEGUE{
    static let LOGIN_ENTER_HOME = "loginEnterHomeSegue"
    static let JOIN_ENTER_HOHE = "joinEnterHomeSegue"
    static let JOIN = "joinSegue"
    static let CHECK_AUTH = "checkAuthSegue"
    static let EDIT_PROFILE = "editProfileSegue"
    static let FOLLOW = "followSegue"
}
