//
//  MapView.swift
//  Amadeus-POI-iOS
//
//  Created by sebastiao Gazolla Costa Junior on 17/08/22.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 51.507222,
            longitude: -0.1275),
        span: MKCoordinateSpan(
            latitudeDelta: 0.5,
            longitudeDelta: 0.5))
    
    @State var city: City
    
    var body: some View {
        Map(coordinateRegion:$region)
            .onAppear{
                if let coord = city.placemark?.location?.coordinate {
                    self.region = MKCoordinateRegion(
                                        center: coord,
                                        span:MKCoordinateSpan(
                                            latitudeDelta: 0.5,
                                            longitudeDelta: 0.5))
                }
            }
    }
    
}

struct MapPreviewWrapper:View {
    var _cds: CityDataService
    init() {
        self._cds = CityDataService.instance
        self._cds.currentCity = City(name:"Brasilia", country:"Brasil", flagIconURL: "BR")
    }
    var body: some View {
        MapView(city: _cds.currentCity!)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapPreviewWrapper()
    }
}
