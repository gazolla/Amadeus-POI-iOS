//
//  CityInfoView.swift
//  Amadeus-POI-iOS
//
//  Created by sebastiao Gazolla Costa Junior on 17/08/22.
//

import SwiftUI

struct CityInfoView: View {
    @State var city:City
    @State private var isLoading = false
    @StateObject private var pds = POIDataService.instance

    var body: some View {
        List{
            cityInfo
            if let errorModel = pds.amadeusError{ showErrors(errorModel: errorModel) }
            if let dataModel = pds.pois { showresults(dataModel: dataModel) }
            if isLoading { showProgress }
        }
        .onAppear(perform: searchCityPOI)
    }
    
    var cityInfo: some View {
        HStack{
            Image(city.flagIconURL ?? "empty")
                .frame(alignment: .leading)
            VStack(alignment: .leading){
                Text(city.name ?? "")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment:.leading)
                Text(city.country ?? "")
                    .fontWeight(.thin)
            }
        }

    }
    
    func searchCityPOI(){
        Task{
            if let latitude:Double = city.placemark?.location?.coordinate.latitude,
               let longitude:Double = city.placemark?.location?.coordinate.longitude {
                isLoading = true
                await pds.loadPointsOfInterest(latitude:latitude, longitude:longitude)
                isLoading = false
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
                    VStack(alignment: .leading){
                        Text(poi.name!)
                            .font(.headline.weight(.bold))
                        Text(poi.category!)
                            .font(.subheadline.weight(.light))
                    }
            }
        }
    }
    
    var showProgress: some View{
        Section(header: Text("Searching Points of Interest")) {
            ProgressView()
        }
    }

}

struct CityInfoWrapper:View{
    let city = City(name:"Brasilia", country:"Brasil", flagIconURL: "BR", placemark: nil)
    var body: some View {
        CityInfoView(city: city)
    }
}
struct CityInfoView_Previews: PreviewProvider {
    static var previews: some View {
        CityInfoWrapper()
    }
}
