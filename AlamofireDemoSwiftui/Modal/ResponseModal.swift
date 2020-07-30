//
//  ResponseModal.swift
//  AlamofireDemoSwiftui
//
//  Created by Chirag's on 17/04/20.
//  Copyright © 2020 Chirag's. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper
class ResponseModel: Mappable {
    var status: Bool?
    var message: String?
    var error: [String]?
    var type: String?
    required init?(map: Map) {
    }
    func mapping(map: Map) {}
}
