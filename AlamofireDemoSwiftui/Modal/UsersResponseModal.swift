//
//  UsersResponseModal.swift
//  AlamofireDemoSwiftui
//
//  Created by Chirag's on 17/04/20.
//  Copyright © 2020 Chirag's. All rights reserved.
//

import UIKit
import ObjectMapper
class UsersResponseModal: ResponseModel {
    var data : [UserData]?
    override func mapping(map: Map) {
        data <- map["data"]
    }
}
class UserData: ResponseModel,Identifiable {
    var id: Int?
    var name: String?
    var username: String?
    var email: String?
    var avatar: String?
    override func mapping(map: Map) {
        id <- map["id"]
        name <- map["first_name"]
        username <- map["last_name"]
        email <- map["email"]
        avatar <- map["avatar"]
    }
}
