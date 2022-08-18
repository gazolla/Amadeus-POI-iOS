//
//  CityInfoView.swift
//  Amadeus-POI-iOS
//
//  Created by sebastiao Gazolla Costa Junior on 17/08/22.
//

import SwiftUI

struct CityInfoView: View {
    @State var city:City
    var body: some View {
        List{
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
