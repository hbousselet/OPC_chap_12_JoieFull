//
//  CatalogView.swift
//  OPC_chap_12_JoieFull
//
//  Created by Hugues BOUSSELET on 23/07/2025.
//

import SwiftUI

struct CatalogView: View {
    @Environment(ClothesViewModel.self) private var clothes
    let rows = [GridItem(.adaptive(minimum: 148, maximum: 200))]

    
    @ViewBuilder
    var body: some View {
        NavigationSplitView {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    Section(header: Text("Tops")) {
                        customLazyHGrid(products: clothes.tops)
                        //                        .frame(width: 404, height: 300)
                    }
                    Section(header: Text("Bas")) {
                        customLazyHGrid(products: clothes.bottoms)
                    }
                    Section(header: Text("Sacs")) {
                        customLazyHGrid(products: clothes.accessories)
                    }
                    Section(header: Text("Chaussures")) {
                        customLazyHGrid(products: clothes.shoes)
                    }
                }
                .padding(.leading, 20)
            }

        } detail: {
            Text("Select a product")
        }
        .task {
            await clothes.fetchProducts()
        }
    }
    
    func customLazyHGrid(products: [Product]) -> some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows) {
                ForEach(products) { product in
                    VStack(alignment: .leading) {
                        AsyncImage(url: URL(string: product.picture.url)) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .clipped()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 198, height: 198)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        HStack {
                            Text(product.name)
                            Spacer()
                            Image(systemName: "star.fill")
                                .foregroundStyle(.yellow)
                            Text("\(Double.random(in: 1...5), specifier: "%.1f")")
                        }
                        HStack {
                            Text("\(product.price, specifier: "%.2f") €")
                            Spacer()
                            Text("\(product.originalPrice, specifier: "%.2f")€")
                        }
                    }
                }
            }
        }
    }
}
