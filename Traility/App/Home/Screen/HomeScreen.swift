//
//  HomeScreen.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/14/23.
//

import SwiftUI

struct HomeScreen: View {
    @StateObject private var homeViewModel = HomeViewModel()
    @State private var isAppBarHidden : Bool = false
    @State private var activityItem : ActivityItem? = nil

    var body: some View {
            ZStack {
                ItemsCollectionView(viewModel: homeViewModel)
                HomeHeaderView()
                if homeViewModel.showLoadingIndicator {
                    Color.black.opacity(0.5).ignoresSafeArea()

                    HStack(spacing: 15) {
                        ProgressView( )
                        Text("Loading…")
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .shadow(radius: 3)
                    .background {
                        Color.white
                    }
                    .cornerRadius(8)

                    
                }
            }
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .detail(let park) : PlaceDetailPage(place: park, detailVM: DetailViewModel(place: park))
                }
            }
            .environmentObject(homeViewModel)
        
        .onReceive(homeViewModel.$activityItems, perform: { parks in
            guard let parks = parks else { return }
            self.activityItem = ActivityItem(parks: parks)
        })
        .sheet(item: $activityItem) { item in
            ParksActivityList(title: "", parks: item.parks)
        }

    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}

// destination enum
enum Destination : Hashable {
    case detail(ParkViewModel)
}

struct ActivityItem : Identifiable , Hashable {
    
    let id : UUID = UUID()
    let parks : [ParksForActivityViewModel]
}
