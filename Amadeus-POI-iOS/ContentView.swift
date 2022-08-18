//
//  ContentView.swift
//  Amadeus-POI-iOS
//
//  Created by sebastiao Gazolla Costa Junior on 17/08/22.
//

import SwiftUI

struct ContentView: View {
    @State private var showSearchCity: Bool = false
    @StateObject private var cds = CityDataService.instance
    var body: some View {
        NavigationView{
            if cds.selectedCity == nil {
                CityEmptyView()
                    .modifier(CityListModifier(showSearchCity: showSearchCity, cds: cds))
            } else {
                CityInfoView(city: cds.selectedCity!)
                    .modifier(CityListModifier(showSearchCity: showSearchCity, cds: cds))
                    .navigationBarItems(leading:
                        Button("clear City") {
                            cds.selectedCity = nil
                        }
                    )
                    
            }
        }
    }
}

struct CityListModifier: ViewModifier {
    @State var showSearchCity: Bool
    @ObservedObject var cds:CityDataService
    func body(content: Content) -> some View {
        content
            .navigationTitle("City")
            .navigationBarItems(trailing:
                    Button("search City") {
                        showSearchCity.toggle()
                    }
                    .disabled(cds.selectedCity != nil)
                    .sheet(isPresented: $showSearchCity) {
                        CitySearchView(cds:cds)
                    })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
