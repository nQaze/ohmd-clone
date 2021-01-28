//
//  UserModel.swift
//  OhMD
//
//  Created by Nabil Kazi on 09/01/21.
//  Copyright © 2021 Nabil Kazi. All rights reserved.
//

import Foundation

enum UserType {
    case patient, doctor
}

struct UserModel {
    var id: String?
    var name: String?
    var email: String?
    var mobile: String?
    var password: String?
    var code: String?
//    var userType: UserType?
}
