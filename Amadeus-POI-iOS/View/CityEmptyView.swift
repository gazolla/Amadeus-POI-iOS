//
//  CityEmptyView.swift
//  Amadeus-POI-iOS
//
//  Created by sebastiao Gazolla Costa Junior on 17/08/22.
//

import SwiftUI

struct CityEmptyView: View {
    var body: some View {
        ScrollView{
            VStack(spacing: 10) {
                
                Image("City")
                    .padding()
                Text ("There is no City!")
                    .font(.title)
                    .fontWeight(.semibold)
                Text("You should click the search button and add one!")
                    .multilineTextAlignment(.center)
                    .padding(40)
            }
        }
        .frame(maxWidth:.infinity, maxHeight:.infinity)
    }
}

struct CityEmptyView_Previews: PreviewProvider {
    static var previews: some View {
        CityEmptyView()
    }
}
