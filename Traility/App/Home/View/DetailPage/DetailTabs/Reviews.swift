//
//  Review.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/22/23.
//

import SwiftUI

struct Review: View {
    var body: some View {
        VStack {
            HStack {
                Text("Overall Rating")
                    .font(.poppins(size: 15, weight: .regular))
                    .foregroundColor(.black.opacity(0.6))
                
                Spacer()
            }
            .padding(.horizontal)
            HStack(alignment : .center, spacing: 15) {
                Text("4.5")
                    .font(.poppins(size: 40, weight: .black))
                    .kerning(-0.5)
                    .foregroundColor(.black.opacity(0.7))
                VStack(alignment : .leading, spacing: 1) {
                    StarsView(rating: 4.5)
                        .frame(maxWidth: 150)
                    
                    Text("40 total reviews")
                        .font(.poppins(size: 12, weight: .regular))
                        .foregroundColor(.gray)
                }
                
                
                Spacer()
            }
            .cornerRadius(20)
            .padding(.horizontal)
            
            ReviewsDistribution()
            
            HStack {
                Text("Reviews")
                    .font(.poppins(size: 18, weight: .bold))
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 25)
            
                ForEach(0 ..< 5) { item in
                    ReviewListRow()
                        .padding()
            }
        }
        .padding(.vertical)
    }
}

struct Review_Previews: PreviewProvider {
    static var previews: some View {
        Review()

    }
}

