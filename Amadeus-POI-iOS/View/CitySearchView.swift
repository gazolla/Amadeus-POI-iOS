//
//  CitySearchView.swift
//  Amadeus-POI-iOS
//
//  Created by sebastiao Gazolla Costa Junior on 17/08/22.
//

import SwiftUI

struct CitySearchView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText = ""
    @ObservedObject var cds: CityDataService
    var body: some View {
        NavigationView{
            VStack{
                SearchBar(text: $searchText)
                    .padding(.top)
                if let city = cds.currentCity {
                    CityDetailView(dismissAction: dismissSheet, cds: cds)
                    MapView(city: city)
                        .presentationDetents([ .medium, .large])
                } else {
                    MapView(city: cds.currentCity ?? City())
                        .presentationDetents([ .medium, .large])
                }
            }
            .navigationTitle("Search City")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }))
        }
    }
    
    private func dismissSheet(){
        dismiss()
    }

}

struct Preview: View {
    var cds = CityDataService.instance
    var body: some View {
        CitySearchView(cds:cds)
    }
}

struct SearchCityView_Previews: PreviewProvider {
    static var previews: some View {
        Preview()
    }
}
