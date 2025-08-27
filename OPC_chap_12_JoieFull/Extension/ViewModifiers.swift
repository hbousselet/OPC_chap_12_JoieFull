//
//  ViewModifiers.swift
//  OPC_chap_12_JoieFull
//
//  Created by Hugues BOUSSELET on 25/07/2025.
//

import Foundation
import SwiftUI

struct TitleSection: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("SFProDisplay", size: 22))
            .scaledToFill()
            .font(.title)
            .minimumScaleFactor(0.5)
    }
}

extension View {
    public func titleSection() -> some View {
        modifier(TitleSection())
    }
}
