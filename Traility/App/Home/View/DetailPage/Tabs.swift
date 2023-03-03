//
//  TabBar.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/22/23.
//

import SwiftUI

struct Tab {
    var title: String
}
struct Tabs: View {
    var fixed = true
    var tabs: [Tab]
    var geoWidth: CGFloat
    @Binding var selectedTab: Int
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                VStack(spacing: 0) {
                    HStack(spacing: 0) {
                        ForEach(0 ..< tabs.count, id: \.self) { row in
                            VStack(spacing: 0) {
                                
                                // Text
                                Text(tabs[row].title)
                                    .font(.poppins(size: 16, weight: .semiBold))
                                    .foregroundColor(
                                        selectedTab == row ? Color(TrailityColor.dominantColor) : .black)
                                    .frame(width: fixed ? (geoWidth / CGFloat(3.1)) : .none, height: 52)
                                    .contentShape(Rectangle())
                                // Bar Indicator
                                Rectangle().fill(selectedTab == row ? Color(TrailityColor.primary) : Color.clear)
                                    .frame(height: 3)
                                    .padding(.horizontal, 10)
                            }.fixedSize()
                            
                            
                                .accentColor(Color.white)
                                .buttonStyle(PlainButtonStyle())
                                .onTapGesture {
                                    withAnimation {
                                        selectedTab = row
                                    }
                                }
                        }
                    }
                    .onChange(of: selectedTab) { target in
                        withAnimation {
                            proxy.scrollTo(target)
                        }
                    }
                }
            }
        }
        .frame(height: 55)
        
    }
}
struct Tabs_Previews: PreviewProvider {
    static var previews: some View {
        Tabs(fixed: true,
             tabs: [.init(title: "Tab 1"),
                    .init(title: "Tab 2"),
                    .init(title: "Tab 3")],
             geoWidth: 375,
             selectedTab: .constant(0))
    }
}
