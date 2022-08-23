//
//  CityDataService.swift
//  Amadeus-POI-iOS
//
//  Created by sebastiao Gazolla Costa Junior on 17/08/22.
//

import Foundation
import MapKit

class CityDataService: NSObject, ObservableObject {
    static let instance = CityDataService()
    private override init(){
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    enum span {
        static let city = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        static let location = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    }
    
    static let startingLocation = CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054)
    @Published var currentCity:City?
    @Published var selectedCity:City? {
        didSet{
            if let coord = selectedCity?.placemark?.location?.coordinate {
                region = MKCoordinateRegion( center: coord, span:span.city)
            }
        }
    }

    let locationManager:CLLocationManager = CLLocationManager()
    @Published var region =  MKCoordinateRegion(center: startingLocation, span: span.city)
    
    
    func clearResults(){
        currentCity = nil
        selectedCity = nil
        locationManager.startUpdatingLocation()
    }
    
    func setLocationRegion(index:Int){
        let pds = POIDataService.instance
        if let poi = pds.pois?.data?[index]{
            region = MKCoordinateRegion(center: poi.coordinate, span:span.location)
            pds.selectedPOI = poi
        }
    }

    func addCity(){
        if let city = currentCity {
            locationManager.stopUpdatingLocation()
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

extension CityDataService: CLLocationManagerDelegate{

    private func checkLocationAuthorization(){
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("Your location is restricted")
        case .denied:
            print("Your have denied this app location permition.")
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            region = MKCoordinateRegion(center: location.coordinate, span: span.location)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}
