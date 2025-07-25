//
//  CatalogView.swift
//  OPC_chap_12_JoieFull
//
//  Created by Hugues BOUSSELET on 23/07/2025.
//

import SwiftUI

struct CatalogView: View {
    @Environment(ClothesViewModel.self) private var clothes
//    let rows = [GridItem(.adaptive(minimum: 148, maximum: 200))]
    let rows = [GridItem(.fixed(198))]

    
    @ViewBuilder
    var body: some View {
        NavigationSplitView {
            ScrollView(.vertical) {
                VStack(alignment: .leading) {
                    Section(header: Text("Tops").titleSection()) {
                        customLazyHGrid(products: clothes.tops)
                    }
                    Section(header: Text("Bas").titleSection()) {
                        customLazyHGrid(products: clothes.bottoms)
                    }
                    .padding(.bottom, 18)
                    Section(header: Text("Sacs").titleSection()) {
                        customLazyHGrid(products: clothes.accessories)
                    }
                    .padding(.bottom, 18)
                    Section(header: Text("Chaussures").titleSection()) {
                        customLazyHGrid(products: clothes.shoes)
                    }
                }
                .padding(.leading, 20)
            }

        } detail: {
            Text("Select a product")
        }
        .task(priority: .high) {
            await clothes.fetchProducts()
        }
    }
    
    func customLazyHGrid(products: [Product]) -> some View {
        ScrollView(.horizontal) {
            LazyHGrid(rows: rows) {
                ForEach(products) { product in
                    VStack(alignment: .leading) {
                        ZStack(alignment: .bottomTrailing) {
                            clothesImage(url: product.picture.url)
                            likes(product.likes)
                                .padding(.bottom, 11.83)
                                .padding(.trailing, 11.36)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityHidden(true)
                        VStack(alignment: .leading) {
                            HStack(alignment: .center) {
                                Text(product.name)
                                    .frame(width: 100)
                                    .lineLimit(1)
                                    .font(.system(size: 14, weight: .semibold))
                                Spacer()
                                HStack(alignment: .center) {
                                    Image(systemName: "star.fill")
                                        .foregroundStyle(.orange)
                                    Text("\(Double.random(in: 1...5), specifier: "%.1f")")
                                        .font(.system(size: 14, weight: .regular))
                                }
                                .accessibilityElement(children: .combine)
                                .accessibilityLabel("Rating: \(Double.random(in: 1...5), specifier: "%.1f")")

                            }
                            HStack(alignment: .center) {
                                Text("\(product.price, specifier: "%.2f") €")
                                Spacer()
                                Text("\(product.originalPrice, specifier: "%.2f")€")
                                    .strikethrough()
                                    .accessibilityLabel("Ancien prix: \(product.originalPrice, specifier: "%.2f")€")
                            }
                            .font(.system(size: 14, weight: .regular))
                        }
                        .padding(.horizontal, 8)
                    }
                    .accessibilityHint("Cliquer pour plus de détails")
                }
            }
        }
    }
    
    func clothesImage(url: String) -> some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .scaledToFill()
                .clipped()
        } placeholder: {
            ProgressView()
        }
        .frame(width: 198, height: 198)
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
    
    func likes(_ likes: Int ) -> some View {
        Capsule()
            .fill(.white)
            .overlay(
                HStack(alignment: .center) {
                    Image(systemName: "heart")
                        .font(.system(size: 14, weight: .semibold))
                    Text(likes.description)
                }
//                    .padding(.leading, 2)
//                    .padding(.trailing, -6)
            )
            .frame(width: 49.11, height: 26.84)
    }
}
