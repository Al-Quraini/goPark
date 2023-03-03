//
//  TabView.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/22/23.
//

import SwiftUI

struct TabView: View {
    @Binding var navbarOffset : CGFloat
    @Binding var startNavbarOffset : CGFloat
    @Binding var imageSize : CGSize
    @Binding var selectedTab : Int
    @EnvironmentObject var place : ParkViewModel
    @State private var showingOptions = false

    var body: some View {
        OffsettableScrollView(showsIndicator: false,
        onOffsetChanged: { offset in
            if startNavbarOffset == 0 {
                startNavbarOffset = offset
            }
            navbarOffset = offset - startNavbarOffset
        }){
            VStack {
                Color.clear.frame(height: imageSize.height > 10 ? imageSize.height - 10 : imageSize.height )
                ZStack {
                    Color(.systemBackground)
                    switch selectedTab {
                    case 0 : Overview(showingOptions: $showingOptions)
                    case 1 : Activities()
                    default : EmptyView()
                    }
                }
            }.padding(.bottom, 30)
        }
        .padding(0)
        .confirmationDialog("", isPresented: $showingOptions) {
            Button("Google Maps") {
                MapServices().getDirections(mapApp: .googleMaps, lat: place.latitude, long: place.longitude, name: place.name)
            }
            
            Button("Apple Maps") {
                MapServices().getDirections(mapApp: .appleMaps, lat: place.latitude, long: place.longitude, name: place.name)
            }
           
        }
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabView(navbarOffset: .constant(100), startNavbarOffset: .constant(20), imageSize: .constant(CGSize(width: 100, height: 500)), selectedTab: .constant(0))
    }
}
