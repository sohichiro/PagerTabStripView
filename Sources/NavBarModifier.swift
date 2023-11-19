//
//  NavBarModifier.swift
//  PagerTabStripView
//
//  Copyright © 2021 Xmartlabs SRL. All rights reserved.
//

import SwiftUI

struct NavBarModifier: ViewModifier {
    @Binding private var selection: Int

    public init(selection: Binding<Int>) {
        self._selection = selection
    }

    func body(content: Content) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if !style.placedInToolbar {
                content
                NavBarWrapperView(selection: $selection)
                    //.background(Color.init(red: 51 / 255, green: 51 / 255, blue: 51 / 255).opacity(186 / 255))
            } else {
                content.toolbar(content: {
                    ToolbarItem(placement: .principal) {
                        NavBarWrapperView(selection: $selection)
                    }
                })
            }
        }
    }
    @Environment(\.pagerStyle) var style: PagerStyle
}

struct NavBarWrapperView: View {
    @Binding private var selection: Int

    public init(selection: Binding<Int>) {
        self._selection = selection
    }

    var body: some View {
        switch self.style {
        case .bar:
            IndicatorBarView { Rectangle() }
                .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
        case .segmentedControl:
            SegmentedNavBarView(selection: $selection)
        case .barButton:
            IndicatorBarView { Rectangle() }.background(style.backgroundColor)
            FixedSizeNavBarView(selection: $selection) { EmptyView() }
        case .scrollableBarButton:
            ScrollableNavBarView(selection: $selection)
        case .custom(_, _, _, let indicator, let background):
            IndicatorBarView { indicator() }.background(style.backgroundColor)
            FixedSizeNavBarView(selection: $selection) { background() }
        }
    }

    @Environment(\.pagerStyle) var style: PagerStyle
}
