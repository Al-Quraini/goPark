//
//  Activities.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/13/23.
//

import SwiftUI

struct Activities: View {
    @EnvironmentObject var place : ParkViewModel

    var body: some View {
        VStack(alignment: .leading) {
        Text("Activities")
            .font(.poppins(size: 20, weight: .semiBold))
            .padding(.vertical)
            ForEach(place.activities, id: \.self) { activity in
                HStack {
                    Image(AssetImageName.nps)
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .frame(width: 35, height: 35)
                    
                    Text(activity.name)
                        .font(.poppins(size : 14, weight: .regular))
                    
                    Spacer()
                }
            }
        }.padding()
    }
}

struct Activities_Previews: PreviewProvider {
    static var previews: some View {
        Activities()
    }
}
