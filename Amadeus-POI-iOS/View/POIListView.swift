//
//  CityInfoView.swift
//  Amadeus-POI-iOS
//
//  Created by sebastiao Gazolla Costa Junior on 17/08/22.
//

import SwiftUI
import MapKit

struct POIListView: View {
    @StateObject private var pds = POIDataService.instance
    @StateObject private var cds = CityDataService.instance
    @State var StateViewShowPOI:(()->())?
    @State var region:MKCoordinateRegion =  MKCoordinateRegion(center: CityDataService.startingLocation, span: CityDataService.span.city)
    var body: some View {
        List{
            if let tokenError = pds.amadeusTokenError { showTokenErrors(tokenError: tokenError) }
            if let errorModel = pds.amadeusError{ showErrors(errorModel: errorModel) }
            if let dataModel = pds.pois { showresults(dataModel: dataModel) }
        }
    }

    @ViewBuilder func showTokenErrors(tokenError:AmadeusTokenError) -> some View{
        Section(header: Text("Error")) {
                    VStack(alignment: .leading){
                        Text(tokenError.error ?? "")
                            .font(.headline.weight(.bold))
                        Text(tokenError.error_description ?? "")
                            .font(.headline.weight(.thin))
                        Text("code: \(tokenError.code ?? 0)")
                        Text(tokenError.title ?? "")
                            .font(.headline.weight(.regular))
                    }
        }
    }
    
    @ViewBuilder func showErrors(errorModel:ErrorModel) -> some View{
        Section(header: Text("Error")) {
            ForEach(errorModel.errors!){ error in
                    VStack(alignment: .leading){
                        Text("code: \(error.code ?? 0)")
                        Text("status: \(error.status ?? 0)")
                        Text(error.title ?? "")
                            .font(.headline.weight(.bold))
                        Text(error.detail ?? "")
                            .font(.subheadline.weight(.semibold))
                    }
            }
        }
    }
    
    @ViewBuilder func showresults(dataModel:DataModel) -> some View{
        Section(header: Text("Points of Interest")) {
            ForEach(dataModel.data!){ poi in
                Button {
                    if let geoCode = poi.geoCode{
                            setLocationRegion(geoCode:geoCode)
                    }
                } label: {
                    VStack(alignment: .leading){
                        Text(poi.name!)
                            .font(.headline.weight(.bold))
                        Text(poi.category!)
                            .font(.subheadline.weight(.light))
                    }
                }
            }
        }
        .onChange(of: region) { region in
            cds.region = region
        }
    }
    
    func setLocationRegion(geoCode:GeoCode){
        if let lat = geoCode.latitude, let lng = geoCode.longitude {
            let coord = CLLocationCoordinate2D(latitude: lat, longitude: lng)
            region = MKCoordinateRegion( center: coord, span:CityDataService.span.location)
        } else {
            print("Can't set location Region....")
        }
    }
}

struct CityInfoView_Previews: PreviewProvider {
    static var previews: some View {
        POIListView()
    }
}
