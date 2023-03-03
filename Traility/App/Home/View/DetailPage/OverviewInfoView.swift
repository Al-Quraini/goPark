//
//  OverviewInfoView.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/26/23.
//

import SwiftUI

struct OverviewInfoView: View {
    @EnvironmentObject var place : ParkViewModel
    @State private var showWebView : Bool = false
    
    var body: some View {
        VStack (spacing : 15){

            OverviewInfoViewRow(title: "Website", info: "click here") {
                showWebView.toggle()
            }

            OverviewInfoViewRow(title: "Park code", info: place.parkCode, onTap: nil)
                        
            OverviewInfoViewRow(title: "designation", info: place.designation, onTap: nil)
            
        }.fullScreenCover(isPresented: $showWebView) {
            if let url = place.url, let url = URL(string: url) {
                ZStack (alignment : .topLeading){
                    WebView(url: url)
                    Button {
                        showWebView.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                            .padding(10)
                    }
                    .foregroundColor(.black)
                    .background(.white)
                    .clipShape(Circle())
                    .padding()
                    .shadow(color: Color(.sRGBLinear, white: 0, opacity:  0.33)
                            ,radius: 5, x: 2, y: 1)
                }
            }
        }
    }
}


struct OverviewInfoViewRow: View {
    let title : String
    let info : String
    let onTap : (() -> ())?
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.poppins(size: 14))
            Spacer()
            
            if let onTap = onTap {
                Button(action: onTap, label: {
                    infoText
                        .underline()
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: 150, alignment: .leading)
                }).frame(maxWidth: 150, alignment: .leading)
            } else {
                infoText
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: 150, alignment: .leading)
            }
        }
    }
    
    var infoText : some View {
        Text(info)
            .font(.poppins(size: 13, weight: .light))
            .multilineTextAlignment(.leading)
            
    }
}

struct OverviewInfoView_Previews: PreviewProvider {
    static var previews: some View {
        OverviewInfoView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
