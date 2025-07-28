//
//  OPC_chap_12_JoieFullApp.swift
//  OPC_chap_12_JoieFull
//
//  Created by Hugues BOUSSELET on 23/07/2025.
//

import SwiftUI

@main
struct OPC_chap_12_JoieFullApp: App {
    @State private var clothes = ClothesViewModel()
    
    var body: some Scene {
        WindowGroup {
            CatalogView()
                .environment(clothes)
        }
    }
}
