//
//  SearchResultRow.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/21/23.
//

import SwiftUI

struct SearchResultRow: View {
    let result : ParkViewModel
    var body: some View {
        VStack(alignment: .leading) {
            HStack (spacing: 12) {
                
                RemoteImageLoader(imageUrl: result.image, aspectRatio: .fill)
                .frame(width: 100, height: 80)
                .background(Color(.systemGray4))
                .cornerRadius(10)
                .clipped()
                
                VStack(alignment: .leading, spacing : 5) {
                    Text(result.name)
                        .font(.poppins(size : 15, weight: .medium))
                        .multilineTextAlignment(.leading)
                    
                    Text("\(result.city), \(result.state)")
                        .font(.poppins(size : 12, weight: .light))
                        .multilineTextAlignment(.leading)
                }
            }
//            Divider().padding()
        }
        .listRowSeparator(.hidden)
        .padding(.vertical, 10)
    }
}

struct SearchResultRow_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultRow(result: PreviewConstantParameter.parkViewModel)
            .previewLayout(.sizeThatFits)
        
    }
}
