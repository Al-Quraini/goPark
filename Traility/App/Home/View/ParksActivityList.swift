//
//  ParksActivityList.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 2/27/23.
//

import SwiftUI

struct ParksActivityList: View {
    let title : String
    let parks : [ParksForActivityViewModel]
    var body: some View {
        NavigationView {
            List {
                ForEach(self.parks, id: \.self) { park in
                    HStack {
                        VStack(alignment : .leading, spacing: 10) {
                            Text("\(park.parkName)")
                                .font(.poppins(size: 15, weight: .medium))
                            
                            Text("\(park.states)")
                                .font(.poppins(size: 12, weight: .light))
                        }
                    }
                }
            }
            .navigationTitle(parks.first?.activityName ?? "")
        }
    }
}

struct ParksActivityList_Previews: PreviewProvider {
    static var previews: some View {
        ParksActivityList(title: "title", parks: [])
    }
}
