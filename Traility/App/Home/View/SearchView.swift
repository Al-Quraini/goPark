//
//  SearchView.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/19/23.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var searchResult : [ParkViewModel] = []
    var body: some View {
        List(searchResult, id: \.self) { result in
            ZStack(alignment: .leading) {
                SearchResultRow(result: result)
                    .onTapGesture {
                        hideKeyboard()
//                        homeViewModel.path.append(Destination.detail(result))
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goToDetailResult"), object: self, userInfo: ["park" : result])
                    }
                
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .background(Color(.systemBackground))
        .listRowSeparator(.hidden, edges: .all)
        .onReceive(homeViewModel.$searchResult) { result in
            switch result {
            case .initial : self.searchResult = []
            case .some(let models) :
                self.searchResult = models
            case .none : self.searchResult = []
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(HomeViewModel())
    }
}


