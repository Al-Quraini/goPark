//
//  PlaceDetailPage.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/21/23.
//

import SwiftUI
import SimpleToast

//MARK: - View
struct PlaceDetailPage: View {
    @State private var navbarOffset : CGFloat = 0
    @State private var startNavbarOffset : CGFloat = 0
    @State private var barSize : CGSize = .zero
    @State private var imageSize : CGSize = .zero
    @State private var selectedTab : Int = 0
    @State private var imageDetailOffset = CGSize.zero
    @State private var clicked: Bool = false
    @State private var showToast: Bool = false
    @StateObject var place : ParkViewModel
    @StateObject var detailVM : DetailViewModel
    let tabs = [Tab(title: "Overview"),
                Tab(title: "Activities")]
    
    private let toastOptions = SimpleToastOptions(
            hideAfter: 1,
            animation: .default,
            modifierType: .slide
        )
    
    var body: some View {
        ZStack(alignment : .top) {
            TabView(navbarOffset: $navbarOffset, startNavbarOffset: $startNavbarOffset, imageSize: $imageSize, selectedTab: $selectedTab)
            
            VStack(spacing : 0) {
                DetailImageView(clicked: $clicked, imageSize: $imageSize, perform: getBarOpacity)

                HStack(spacing : 0) {
                    Tabs(fixed: true,
                         tabs: tabs,
                         geoWidth: UIScreen.screenWidth,
                         selectedTab: $selectedTab)

                }
                .background(Color(.systemBackground)
                    .shadow(color : Color(.systemGray4),radius: 2,x: 3, y: 2)

                    .ignoresSafeArea())

            }
            .offset(y : getOffset())
            .ignoresSafeArea()
            
            PlaceDetailNavBar(barSize: $barSize, perform: getBarOpacity)
        }
        .navigationBarHidden(true)
        .overlay(content: {
            if clicked {
                Color.black.overlay{
                    ImageCarousel(clicked: $clicked, onChanged: onChanged, onEnded: onEnded)
                        .frame(width: UIScreen.screenWidth)
                        .clipped()
                        
                }
                    .transition(.asymmetric(insertion: .opacity, removal: .move(edge: .top).combined(with: .opacity)))
                    .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight  + (DisplaySizeManager.getSafeArea()?.bottom ?? 0) + 5)
                    .onDisappear{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HideTabBar"), object: self, userInfo: ["hide" : false])
                    }.onAppear{
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HideTabBar"), object: self, userInfo: ["hide" : true])
                    }
            }
        })
        .simpleToast(isPresented: $showToast, options: toastOptions) {
            if detailVM.isVisited
            {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                    Text("marked as visited")
                }
                .padding()
                .background(.black.opacity(0.8))
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .frame(maxWidth: UIScreen.screenWidth * 0.7)
            } else {
                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.red)
                    Text(" marked as unvisited")
                }
                .padding()
                .background(.black.opacity(0.8))
                .foregroundColor(Color.white)
                .cornerRadius(10)
                .frame(maxWidth: UIScreen.screenWidth * 0.7)
            }
        }
        .onChange(of: detailVM.isVisited, perform: { value in
            showToast = true
        })
        .environmentObject(place)
        .environmentObject(detailVM)
    }
    
}

//MARK: - Functions
extension PlaceDetailPage {
    func getOffset() -> CGFloat {
        let topSafeArea = DisplaySizeManager.getSafeArea()?.top ?? 0
        let safeSize : CGFloat = barSize.height + topSafeArea
        let checkSize = -navbarOffset < imageSize.height - safeSize ? navbarOffset : -imageSize.height + safeSize
        return checkSize < 0 ? checkSize : 0
    }
    
    func getBarOpacity() -> CGFloat {
        let topSafeArea = DisplaySizeManager.getSafeArea()?.top ?? 0
        let safeSize : CGFloat = barSize.height + topSafeArea
        let scrollPercentage = navbarOffset/(imageSize.height - safeSize)
        if scrollPercentage > 0 {
            return 1
        }
        let opacity = 1 + scrollPercentage
        if opacity < 0 {
            return 0
        }
        return abs(opacity)
    }
    
    private func onChanged(value: DragGesture.Value) {
        imageDetailOffset = value.translation
    }
    
    private func onEnded(value: DragGesture.Value) {
        let translation = value.translation
        
        if translation.width > UIScreen.screenWidth/2 || translation.width  < -UIScreen.screenWidth/2 ||
            translation.height > UIScreen.screenHeight/4 || translation.height  < -UIScreen.screenHeight/4 {
            withAnimation {
                clicked = false
            }
            imageDetailOffset = .zero
            return
        }
        withAnimation {
            imageDetailOffset = .zero
        }
        
    }
}

//MARK: - Preview
//struct PlaceDetailPage_Previews: PreviewProvider {
//    static var previews: some View {
//        PlaceDetailPage(place: PreviewConstantParameter.parkViewModel)
//    }
//}
