//
//  MyErrors.swift
//  Gwoekga-ios
//
//  Created by 강민채 on 2020/09/07.
//  Copyright © 2020 minchae. All rights reserved.
//

import Foundation

enum MyError: String, Error{
    case noContent = "😧 로드된 데이터가 없습니다."
    case cantSendEmail = "이메일을 보내지 못했습니다."
    case cantAddUser = "유저를 추가하지 못했습니다. 다시 시도해주세요."
}
