//
//  DataModel.swift
//  Amadeus-POI-iOS
//
//  Created by sebastiao Gazolla Costa Junior on 18/08/22.
//

import Foundation
import MapKit

struct DataModel: Codable {
    let meta: Meta?
    let data: [PointOfInterest]?
}

class PointOfInterest: Codable, Identifiable, Equatable {
    var type, subType, id:String?
    let datumSelf: SelfClass?
    var geoCode: GeoCode?
    var name:String?
    var category:String?
    var rank:Int?
    var tags:[String]?
    
    static func == (lhs: PointOfInterest, rhs: PointOfInterest) -> Bool {
        lhs.id == rhs.id
    }
}

extension PointOfInterest {
    var isValid: Bool {
        return geoCode?.latitude != 0 && geoCode?.longitude != 0
    }
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: (geoCode?.latitude)!, longitude: (geoCode?.longitude)!)
    }
}


struct SelfClass: Codable {
    let href: String?
    let methods: [String]?
}

class GeoCode: Codable{
    var latitude:Double?
    var longitude:Double?
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

extension PointOfInterest: CustomStringConvertible {
    var description: String{
        "name:\(name ?? ""), category:\(category ?? ""), lat:\(geoCode?.latitude ?? 0.00), long:\(geoCode?.longitude ?? 0.00)"
    }
}
