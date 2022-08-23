//
//  CityInfoView.swift
//  Amadeus-POI-iOS
//
//  Created by sebastiao Gazolla Costa Junior on 17/08/22.
//

import SwiftUI
import MapKit

struct POIListView: View {
    @ObservedObject private var pds = POIDataService.instance
    @ObservedObject private var cds = CityDataService.instance
    @State var changeStateToShowPOI:(()->())?
    @State private var selectedPOI = -1

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
            .transition(.slide)
        }
    }
    
    @ViewBuilder func showresults(dataModel:DataModel) -> some View{
        Section(header: Text("Points of Interest")) {
            ForEach(0..<dataModel.data!.count, id:\.self){ index in
                Button {
                    selectedPOI = index
                    changeStateToShowPOI?()
                } label: {
                    VStack(alignment: .leading){
                        Text(dataModel.data![index].name!)
                            .font(.headline.weight(.bold))
                        Text(dataModel.data![index].category!)
                            .font(.subheadline.weight(.light))
                    }
                }
                
            }
            .transition(.slide)
            .onChange(of: selectedPOI) { newValue in
                cds.setLocationRegion(index:newValue)
            }
        }
    }
}

struct CityInfoView_Previews: PreviewProvider {
    
    static var previews: some View {
        POIListView()
    }
}
