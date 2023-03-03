//
//  OffsetableScrollView.swift
//  Traility
//
//  Created by Mohammed Al-Quraini on 1/22/23.
//

import SwiftUI

private struct OffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) { }
}

struct OffsettableScrollView<T: View>: View {

    let axes: Axis.Set
    let showsIndicator: Bool
    let onOffsetChanged: (CGFloat) -> Void
    let content: T
    
    init(axes: Axis.Set = .vertical,
         showsIndicator: Bool = true,
         onOffsetChanged: @escaping (CGFloat) -> Void = { _ in },
         @ViewBuilder content: () -> T
    ) {
        self.axes = axes
        self.showsIndicator = showsIndicator
        self.onOffsetChanged = onOffsetChanged
        self.content = content()
    }
    
    var body: some View {
            ScrollView(axes, showsIndicators: showsIndicator) {
                VStack(spacing : 0) {
                    GeometryReader { proxy in
                        Color.clear.preference(
                            key: OffsetPreferenceKey.self,
                            value: proxy.frame(
                                in: .named("ScrollViewOrigin")
                            ).minY
                        )
                    }
                    .frame(width: 0, height: 0)
                    content
                }
            }
            .padding(0)
            .coordinateSpace(name: "ScrollViewOrigin")
            .onPreferenceChange(OffsetPreferenceKey.self,
                                perform: onOffsetChanged)
    }

}
