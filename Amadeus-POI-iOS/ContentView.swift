//
//  ContentView.swift
//  Amadeus-POI-iOS
//
//  Created by sebastiao Gazolla Costa Junior on 17/08/22.
//

import SwiftUI
import MapKit

struct ContentView:View{
    @StateObject private var pds = POIDataService.instance
    @StateObject private var cds = CityDataService.instance
    @State private var searchText = ""
    @State private var viewState:ViewStates = .initial
    @State private var isShowingPOIList = false

    var body: some View{
        ZStack{
            showMap
            .ignoresSafeArea()

            switch viewState {
            case .initial:
                showSearchButton
            case .searching:
                showSearchView
            case .selected:
                showSelectedCityView
            case .listing:
                showProcessingPOI
            case .listed:
                showListPOIView
            case .showPOI:
                showListPOIView
            }
        }
        .onChange(of: viewState, perform: { newValue in
            print("State: \(viewState)")
        })
    }
}

enum ViewStates {
    case initial, searching, selected, listing, listed, showPOI
}

extension ContentView {
    
    var showMap: some View{
        VStack{
            if viewState == .listed || viewState == .showPOI, let pois = pds.pois?.data {
                Map(coordinateRegion: $cds.region, annotationItems: pois.filter { $0.isValid}) { poi in
                    MapMarker(coordinate: poi.coordinate)
                }
            } else {
                Map(coordinateRegion: $cds.region, showsUserLocation: true)
            }
        }
    }
    
    var showSearchButton: some View{
        VStack{
            Button {
                changeStateToSearching()
            } label: {
                Image(systemName: "magnifyingglass.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .topTrailing)
            .padding()
            Spacer()
        }
        .onAppear(perform: cds.clearResults)
    }

    var showSearchView: some View{
        showBasicTopView {
            VStack{
                SearchBar(text: $searchText, dismiss: changeStateToInitial)
                    .frame(height:60)
                if let _ = cds.currentCity {
                    VStack{
                        Divider()
                            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                         CityDetailView(dismissAction: changeStateToSelected, cds: cds)
                    }
                 }
            }
            .onSubmit {
                withAnimation {
                    cds.searchCity(text: searchText)
                }
            }
            .onChange(of: searchText) { newValue in
                if newValue.isEmpty {
                    cds.searchCity(text: newValue)
                }
            }

        }
    }

    var showSelectedCityView: some View{
        showBasicTopView {
            VStack{
                if let city = cds.selectedCity {
                    CityCellView(city: city)
                        .padding()
                }
            }
            .onAppear{
                changeStateToListing()
            }
        }
    }

    var showListPOIView: some View{
        showBasicTopView {
            VStack{
                if let city = cds.selectedCity {
                    HStack{
                        Button {
                            ToggleStateView()
                            withAnimation(.easeInOut) {
                                isShowingPOIList.toggle()
                            }
                         } label: {
                            CityCellView(city: city)
                                .padding(EdgeInsets(top: 0, leading: 40, bottom: 0, trailing: 0))
                        }
                        Button{
                            changeStateToInitial()
                         } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .font(.title2)
                        }
                        .frame(alignment: .topTrailing)
                        .padding(20)
                    }
                    .overlay(alignment:.leading){
                        Image(systemName: "arrow.down")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding()
                            .rotationEffect(Angle(degrees: isShowingPOIList ? 180 : 0))
                    }
                    if isShowingPOIList {
                        POIListView(changeStateToShowPOI: changeStateToShowPOI)
                    }
                }
            }
        }
    }
    
    var showProcessingPOI: some View{
        ZStack{
            showSelectedCityView
            VStack{
                ProgressView()
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .topTrailing)
                    .padding(EdgeInsets(top: 45, leading: 0, bottom: 0, trailing: 45))
                    .onAppear(perform: searchCityPOI)
                Spacer()
            }
        }
    }
    
     @ViewBuilder func showBasicTopView(subViews:(()->some View))-> some View{
         VStack(spacing: 0) {
            VStack{
                subViews()
            }
            .background(.thickMaterial)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.3), radius: 20, x:0, y:15)
            Spacer()
        }
        .padding()
        .animation(.easeInOut, value: viewState)
     }
    
    func searchCityPOI(){
        Task{
            if let city = cds.selectedCity,
                let latitude:Double = city.placemark?.location?.coordinate.latitude,
                    let longitude:Double = city.placemark?.location?.coordinate.longitude {
                        await pds.loadPointsOfInterest(latitude:latitude, longitude:longitude)
             }
        }
        changeStateToListed()
    }

    func ToggleStateView(){
        withAnimation {
            viewState = (viewState == .showPOI) ? .listed : .showPOI
        }
    }
    
    func changeStateToListing(){
        withAnimation {
            viewState = .listing
        }
    }

    func changeStateToSearching(){
        withAnimation {
            viewState = .searching
        }
    }

    func changeStateToListed(){
        withAnimation {
            viewState = .listed
        }
    }

    func changeStateToShowPOI(){
        withAnimation {
            viewState = .showPOI
            isShowingPOIList = false
        }
    }

    func changeStateToInitial(){
        withAnimation {
            viewState = .initial
        }
    }

    func changeStateToSelected(){
        withAnimation {
            viewState = .selected
        }
    }
}



/*struct ContentView: View {
    @State private var showSearchCity: Bool = false
    @StateObject private var cds = CityDataService.instance
    @StateObject private var pds = POIDataService.instance
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
                            cds.clearResults()
                            pds.clearResults()
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
*/
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
