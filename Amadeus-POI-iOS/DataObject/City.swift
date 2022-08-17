//
//  City.swift
//  Amadeus-POI-iOS
//
//  Created by sebastiao Gazolla Costa Junior on 17/08/22.
//

import Foundation
import MapKit

struct City: Identifiable, Equatable{
    var id = UUID()
    var name:String?
    var country:String?
    var flagIconURL: String?
    var placemark:CLPlacemark?
    
    init(placemark:CLPlacemark){
        self.name = placemark.name
        self.country = placemark.country
        self.flagIconURL = placemark.isoCountryCode
        self.placemark = placemark
    }
    
    init(name: String? = nil, country: String? = nil, flagIconURL: String? = nil, placemark: CLPlacemark? = nil) {
        self.name = name
        self.country = country
        self.flagIconURL = flagIconURL
        self.placemark = placemark
    }
    
    static func == (lhs: City, rhs: City) -> Bool {
        lhs.id == rhs.id
    }
}
