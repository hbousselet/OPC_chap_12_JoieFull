//
//  DummyView.swift
//  OPC_chap_12_JoieFull
//
//  Created by Hugues BOUSSELET on 25/07/2025.
//

import SwiftUI

struct DummyView: View {
    var product: ProductViewModel
    var body: some View {
        Text(product.name)
    }
}
