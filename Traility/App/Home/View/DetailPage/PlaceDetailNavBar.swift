//
//  PlaceDetailNavBar.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/22/23.
//

import SwiftUI

struct PlaceDetailNavBar: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    @EnvironmentObject var place : ParkViewModel
    @EnvironmentObject var detailVM : DetailViewModel
    @Binding var barSize : CGSize
    @State private var navBarVisible : Bool = false

    var perform : () -> CGFloat
    var body: some View {
        SizeReader(size: $barSize) {
            HStack(alignment: .top) {
                    Button {
                        self.mode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                            .padding(10)
                    }
                    .foregroundColor(.black)
                    .background(.white)
                    .clipShape(Circle())
                    .shadow(color: Color(.sRGBLinear, white: 0, opacity: perform() * 0.33)
                            ,radius: 5, x: 2, y: 1)
                    
                    Spacer()
                
                Text(place.name)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .font(.poppins(size: 20, weight: .medium))
                    .padding(5)
                    .opacity(navBarVisible ? 1 : 0)
                    .onChange(of: perform()) { opacity in
                        withAnimation {
                            navBarVisible = opacity < 0.2
                        }
                    }
                
                    Spacer()
                
                Menu {
                    Button {
                        detailVM.updateParkStatus()
                        Haptics.shared.play(.light)
                    } label: {
                        Label(detailVM.addedToList ? "Remove from list" : "Add to list", systemImage: detailVM.addedToList ? "xmark" : "checklist.unchecked")
                    }
                    
                    Button {
                        detailVM.updateVisitStatus()
                        Haptics.shared.play(.light)
                    } label: {
                        Label(detailVM.isVisited ? "Mark as not visited" : "Mark as visited",
                              systemImage: detailVM.isVisited ?  "xmark" : "checkmark")
                    }
                    } label: {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .scaledToFit()
                            .rotationEffect(.degrees(-90))
                            .frame(width: 15, height: 15)
                            .padding(10)
                    }
                    .foregroundColor(.black)
                    .background(.white)
                    .clipShape(Circle())
                    .shadow(color: Color(.sRGBLinear, white: 0, opacity: perform() * 0.33)
                            ,radius: 5, x: 2, y: 1)
                }
                .padding(.horizontal)
                .padding(.bottom, 10)
                .background(.white.opacity( 1 - perform()))
        }
    }
}

struct PlaceDetailNavBar_Previews: PreviewProvider {
    static var previews: some View {
        PlaceDetailNavBar(barSize: .constant(.zero), perform: {return 0.0})
    }
}
