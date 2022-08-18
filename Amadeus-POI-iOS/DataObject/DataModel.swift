//
//  DataModel.swift
//  Amadeus-POI-iOS
//
//  Created by sebastiao Gazolla Costa Junior on 18/08/22.
//

import Foundation

struct DataModel: Codable {
    let meta: Meta?
    let data: [PointOfInterest]?
}

class PointOfInterest: Codable, Identifiable {
    var type, subType, id:String?
    let datumSelf: SelfClass?
    var geoCode: GeoCode?
    var name:String?
    var category:String?
    var rank:Int?
    var tags:[String]?
}

struct SelfClass: Codable {
    let href: String?
    let methods: [String]?
}

class GeoCode: Codable{
    var latitude:Double?
    var longitute:Double?
}

struct Meta: Codable {
    let count: Int?
    let links: Links?
}

struct Links: Codable {
    let linksSelf: String?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}
