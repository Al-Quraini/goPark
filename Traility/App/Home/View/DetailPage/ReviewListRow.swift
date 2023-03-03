//
//  ReviewListRow.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/1/23.
//

import SwiftUI

struct ReviewListRow: View {
    var body: some View {
        VStack {
            HStack {
                Circle()
                    .foregroundColor(Color(.systemGray5))
                .frame(width: 40)
                
                VStack(alignment : .leading, spacing : 3) {
                    Text("Donald Trump")
                        .font(.poppins(size: 13, weight: .medium))
                    
                    StarsView(rating: 3.5, spacing: 2)
                        .frame(width: 75)
                }
                Spacer()
                
                Text("2 hrs")
                    .font(.poppins(size: 13, weight: .light))
            }
            
            Text("I recently purchased the Bose QuietComfort 35 II wireless headphones and I am blown away by their sound quality. The noise cancelling feature is top-notch and blocks out any background noise, allowing me to fully immerse in my music. The battery life is also impressive, lasting me over 20 hours on a single charge. The comfort level is unmatched, as the cushioned ear cups and adjustable headband make these headphones feel like they're not even on. Overall, I highly recommend these headphones to anyone looking for an exceptional audio experience.")
                .font(.poppins(size: 13, weight: .light))
                .padding(.vertical)
        }
    }
}

struct ReviewListRow_Previews: PreviewProvider {
    static var previews: some View {
        ReviewListRow()
            .previewLayout(.sizeThatFits)    }
}
