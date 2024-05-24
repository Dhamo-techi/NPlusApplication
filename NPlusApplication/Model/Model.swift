//
//  Model.swift
//  NPlusApplication
//
//  Created by MAC PRO on 15/05/24.
//

import Foundation

struct Model : Codable {
    let products : [Products]?
    let total : Int?
    let skip : Int?
    let limit : Int?
}

struct Products : Codable {
    let id : Int?
    let title : String?
    let description : String?
    let category : String?
    let price : Double?
    let discountPercentage : Double?
    let rating : Double?
    let stock : Int?
    let tags : [String]?
    let brand : String?
    let sku : String?
    let weight : Int?
    let warrantyInformation : String?
    let shippingInformation : String?
    let availabilityStatus : String?
    let returnPolicy : String?
    let minimumOrderQuantity : Int?
    let images : [String]?
    let thumbnail : String?
}
