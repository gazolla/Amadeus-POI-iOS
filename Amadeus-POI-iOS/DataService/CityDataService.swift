//
//  CityDataService.swift
//  Amadeus-POI-iOS
//
//  Created by sebastiao Gazolla Costa Junior on 17/08/22.
//

import Foundation
import MapKit

class CityDataService: ObservableObject {
    static let instance = CityDataService()
    private init() {}
    
    @Published var currencyCity:City?
    
    func searchCity(text:String){
        guard !text.isEmpty else {
            self.currencyCity = nil
            return
        }
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(text){ (placemarks, error) in
            if error != nil {
                print(error!)
            }
            
            if placemarks != nil {
                self.currencyCity = City(placemark: placemarks![0])
            } else {
                self.currencyCity = nil
            }
        
        }
    }
}
