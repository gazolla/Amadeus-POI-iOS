//
//  CityDetailView.swift
//  Amadeus-POI-iOS
//
//  Created by sebastiao Gazolla Costa Junior on 17/08/22.
//

import SwiftUI

struct CityDetailView: View {
    var dismissAction: (()->())?
    @ObservedObject var cds: CityDataService
    @State private var isCitySelected = false
    var body: some View {
        if let city = cds.currentCity {
            VStack(){
                CityCellView(city:city)
                Button {
                    withAnimation {
                        isCitySelected = true
                     }
                    dismissAction!()
                } label: {
                    Text("Select City")
                        .frame(maxWidth: .infinity, maxHeight: 35)
                        .fontWeight(.medium)
                        .background(Color.blue)
                        .foregroundColor(Color.white)
                        .cornerRadius(5)
                }
            }
            .padding()
            .onChange(of: isCitySelected, perform: { newValue in
                cds.addCity()
            })
            .onDisappear{
                cds.currentCity = nil
                isCitySelected = false
            }
        }
    }
}

struct CityCellView:View {
    @State var city: City
    var body: some View {
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

struct PreviewWrapper:View{
    var _cds: CityDataService
    init() {
        self._cds = CityDataService.instance
        self._cds.currentCity = City(name:"Brasilia", country:"Brasil", flagIconURL: "BR")
    }
    var body: some View {
        CityDetailView(cds: _cds)
    }
}

struct CityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewWrapper()
    }
}
