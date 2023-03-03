//
//  ReviewsDistribution.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/1/23.
//

import SwiftUI

struct ReviewsDistribution: View {
    var body: some View {
        VStack(spacing : 0) {
            RatingPercentageView(stars: 5, percentage: 0.84)
            RatingPercentageView(stars: 4, percentage: 0.09)
            RatingPercentageView(stars: 3, percentage: 0.04)
            RatingPercentageView(stars: 2, percentage: 0.02)
            RatingPercentageView(stars: 1, percentage: 0.01)
        }
    }
}

struct ReviewsDistribution_Previews: PreviewProvider {
    static var previews: some View {
        ReviewsDistribution()
    }
}


struct RatingPercentageView : View {
    let stars : Int
    let percentage : Double
    var body: some View {
        
            HStack(spacing : 15) {
                Text("\(stars) star")
                   .font(.poppins(size: 11, weight: .regular))
                   .foregroundColor(Color(TrailityColor.dominantColor))
                   .padding(.leading)
                   .frame(width: 100)
                   .frame(width: UIScreen.screenWidth * 0.1)
                
                    Color(.clear)
                        .frame(maxWidth: 200 + 10, maxHeight: 5)
                        .cornerRadius(12)
                        .background{
                            HStack {
                                Color.yellow
                                    .frame(maxWidth: (percentage + 0.02) * 200, maxHeight: 5)
                                .cornerRadius(12)
                                
                                Spacer()
                            }
                        }
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .clipped()
                .frame(width: UIScreen.screenWidth * 0.55)
                .shadow(color: .white,radius: 1)
                
                Text("\(Int(percentage * 100))%")
                   .font(.poppins(size: 12, weight: .medium))
                   .frame(width: UIScreen.screenWidth * 0.1)
                   .padding(.trailing)
                
            }
        }
}
