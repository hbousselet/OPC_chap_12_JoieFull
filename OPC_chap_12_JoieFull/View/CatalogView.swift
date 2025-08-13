//
//  CatalogView.swift
//  OPC_chap_12_JoieFull
//
//  Created by Hugues BOUSSELET on 25/07/2025.
//

import SwiftUI

struct CatalogView: View {
    @Environment(ClothesViewModel.self) private var clothes
    let rows = [GridItem(.fixed(198))]
    
    @State private var isSelectedItem: Bool = false
    let screenWidth = UIScreen.main.bounds.width
    
    
    @ViewBuilder
    var body: some View {
        NavigationSplitView(columnVisibility: .constant(.all)) {
            ScrollView(.vertical) {
                if clothes.products.isEmpty {
                    ProgressView()
                } else {
                    VStack(alignment: .leading) {
                        sectionView()
                    }
                    .padding(.leading, 17)
                }
            }
//            .toolbar(.hidden, for: .navigationBar)
            .navigationSplitViewColumnWidth(screenWidth * 0.64)
        } detail: {
        }
        .navigationSplitViewStyle(.balanced)
        .task(priority: .high) {
            await clothes.fetchProducts()
        }
    }
    
    private func sectionView() -> some View {
        ForEach(Product.ProductCategory.allCases, id: \.self) { category in
            Section(header: Text(category.rawValue).titleSection()) {
                if let productInCategories = clothes.groupedProducts[category.rawValue] {
                    customLazyHGrid(products: productInCategories)
                }
            }
        }
    }
    
    func customLazyHGrid(products: [Product]) -> some View {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(products) { product in
                        NavigationLink(value: product, label: {
                            VStack(alignment: .leading) {
                                ZStack(alignment: .bottomTrailing) {
                                    ClothesImage(url: product.picture.url, width: 198, height: 198)
                                    Likes()
                                        .padding(.bottom, 11.83)
                                        .padding(.trailing, 11.36)
                                }
                                .accessibilityElement(children: .combine)
                                .accessibilityHidden(true)
                                .padding(.horizontal, 4)
                                DetailsProductDescription(product: product)
                                    .padding(.horizontal, 4)
                            }
                            .accessibilityHint("Cliquer pour plus de détails")
                        })
                    }
                }
            }
        .navigationDestination(for: Product.self) { product in
            ProductDetailsView(product: product, review: "")
        }
    }
}
