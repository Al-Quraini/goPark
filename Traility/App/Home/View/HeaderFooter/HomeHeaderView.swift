//
//  HomeHeaderView.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/15/23.
//

import SwiftUI

struct HomeHeaderView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @State private var searchText : String = ""
    @State var isAppBarHidden : Bool = false
    @FocusState private var isSearchFocused: Bool
    @State private var isSearchMode : Bool = false
    @EnvironmentObject var homeViewModel: HomeViewModel
    var body: some View {
        VStack(spacing: 0) {
            VStack {
                if !isAppBarHidden && !isSearchMode {
                    navBar
                }
                
                searchField
                
                dividerView
                
            }
            .onChange(of: isSearchFocused, perform: { focused in
                withAnimation {
                    if focused {
                        isSearchMode = focused
                    }
                }
            })
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "HomeScreenReset")), perform: { _ in
                //                clearSearch()
                
            })
            .onReceive(homeViewModel.$isAppBarHidden) { isHidden in
                withAnimation(.linear(duration: 0.25)) {
                    self.isAppBarHidden = isHidden
                }
            }
            .background(Color(uiColor: .systemBackground))
            if isSearchMode {
                SearchView()
                    .onDisappear {
                        isSearchFocused = false
                    }
            } else {
                Spacer()
            }
        }
    }
    
    // nav bar
    private var navBar : some View {
        HStack(alignment : .top) {
            Button {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SideBar"), object: self, userInfo: nil)
            } label: {
                Image(systemName: "line.3.horizontal")
                    .resizable()
                    .scaledToFit()
                    .clipped()
                    .foregroundColor(Color(TrailityColor.dominantColor))
                    .frame(width:25, height: 35)
            }
            VStack(alignment: .leading) {
                Text(CalendarManager().getWelcomeMessage())
                    .font(.poppins(size: 20,weight: .light))

            }
            .padding(.horizontal)
            Spacer()

        }.padding(.horizontal)
            .padding(.top, 10)
    }
    
    // search field
    private var searchField :some View {
        HStack {
            HStack(spacing: 0) {
                // text field
                TextField("Search place...", text: $searchText)
                    .focused($isSearchFocused)
                    .autocorrectionDisabled(true)
                    .onChange(of: searchText) { searchText in
                        performSearch(searchText)
                    }
                if homeViewModel.isLoading {
                    ProgressView()
                    
                } else if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(isSearchFocused ? Color(TrailityColor.dominantColor) : .gray)
                    }
                    
                } else {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(isSearchFocused ? Color(TrailityColor.dominantColor) : .gray)
                }
                
            }
            .searchTextFieldModifier(horizontalPadding: 10) {
                isSearchFocused = true
            }
            
            
            if isSearchMode {
                Button {
                    clearSearch()
                } label: {
                    Text("Cancel")
                        .font(.poppins(size: 14, weight: .regular))
                        .foregroundColor(Color(TrailityColor.dominantColor))
                }
                .frame(height: 30)
                .padding(.trailing)
                
            }
        }
    }
    
    // divider view
    private var dividerView : some View {
        Divider()
            .foregroundColor(.gray)
            .shadow(color: isAppBarHidden && !isSearchMode ? Color(UIColor.lightGray) : Color(UIColor.systemBackground), radius: 0)
            .opacity(isAppBarHidden || isSearchMode ? 1 : 0)
            .padding(0)
    }
    
    private func performSearch(_ text : String) {
        homeViewModel.filterPark(for: text)
    }
    
    private func clearSearch() {
        searchText = ""
        isSearchFocused = false
        withAnimation {
            isSearchMode = false
        }
        homeViewModel.clearSearch()
    }
}

struct HomeHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HomeHeaderView()
            .previewLayout(.sizeThatFits)
    }
}
