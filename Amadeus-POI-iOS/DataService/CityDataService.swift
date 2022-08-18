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
    
    @Published var currentCity:City?
    @Published var selectedCity:City?
    
    func clearResults(){
        currentCity = nil
        selectedCity = nil
    }

    func addCity(){
        if let city = currentCity {
            self.selectedCity = city
        } else {
            print("CityViewModel ==>> NO CITY TO ADD")
        }
    }

    func searchCity(text:String){
        guard !text.isEmpty else {
            self.currentCity = nil
            return
        }
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(text){ (placemarks, error) in
            if error != nil {
                print(error!)
            }
            
            if placemarks != nil {
                self.currentCity = City(placemark: placemarks![0])
            } else {
                self.currentCity = nil
            }
        
        }
    }
}
