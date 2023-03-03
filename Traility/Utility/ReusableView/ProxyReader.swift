//
//  SizeReader.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/22/23.
//

import SwiftUI

private struct SizePreferenceKey : PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value _: inout CGSize, nextValue: () -> CGSize) {
           _ = nextValue()
       }
}

struct SizeReader<Content: View>: View {
    @Binding var size: CGSize
        let content: () -> Content
        var body: some View {
            ZStack {
                content()
                    .background(
                        GeometryReader { proxy in
                            Color.clear
                                .preference(key: SizePreferenceKey.self, value: proxy.size)
                        }
                    )
            }
            .onPreferenceChange(SizePreferenceKey.self) { preferences in
                self.size = preferences
            }
        }
    
}
