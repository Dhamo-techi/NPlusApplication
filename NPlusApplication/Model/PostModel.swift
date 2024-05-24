//
//  PostModel.swift
//  NPlusApplication
//
//  Created by MAC PRO on 23/05/24.
//

import Foundation

struct PostModel : Codable {
    let posts : [Posts]?
    let total : Int?
    let skip : Int?
    let limit : Int?
}

struct Posts : Codable {
    let id : Int?
    let title : String?
    let body : String?
    let tags : [String]?
    let views : Int?
    let userId : Int?
}
