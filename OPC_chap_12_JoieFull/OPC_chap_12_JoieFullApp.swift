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
            CatalogViewV2()
                .environment(clothes)
            //verifier si on augmente la taille de la font par défaut le layout doit suivre
            // modifier la vue pour iPad et iPhone afin de ne pas utiliser la partie native (distinguer iPhone et iPad si Ipad créer un nouveau splitView ?)
        }
    }
}
