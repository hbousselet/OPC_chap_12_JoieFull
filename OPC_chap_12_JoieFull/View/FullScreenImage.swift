//
//  FullScreenImage.swift
//  OPC_chap_12_JoieFull
//
//  Created by Hugues BOUSSELET on 13/08/2025.
//

import SwiftUI

struct FullScreenImage: View {
    let width: CGFloat
    let url: String
    var body: some View {
        ClothesImage(url: url,                                                                                              width: width - 32,
                     height: (1.2 * width) - 32)
        .background(.black)
    }
}
