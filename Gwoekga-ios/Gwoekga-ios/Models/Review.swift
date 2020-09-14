//
//  Review.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/09/07.
//  Copyright © 2020 minchae. All rights reserved.
//

import Foundation

struct Review: Codable{
    var postSeq: String = ""
    var title: String
    var written: String
    var star: Float
    var email: String
    var category: String
    var genres : String
    var postTime: String = ""
}
