//
//  CatalogView.swift
//  OPC_chap_12_JoieFull
//
//  Created by Hugues BOUSSELET on 21/08/2025.
//

import SwiftUI

struct CatalogView: View {
    @Environment(ClothesViewModel.self) private var clothes
    @State private var currentSelectedProduct: Product?

    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    private var detailViewWidth = UIScreen.main.bounds.width * 0.36
    
    var body: some View {
        NavigationStack {
            if clothes.products.isEmpty {
                showProgressView()
            } else {
                VStack(alignment: .leading) {
                    if idiom == .pad {
                        HStack(alignment: .center) {
                            sectionView()
                                .padding(.leading, 17)
                            if let selectedProduct = currentSelectedProduct {
                                Divider()
                                ProductDetailsView(product: selectedProduct, review: "")
                                    .frame(width: detailViewWidth)
                            }
                        }
                    } else {
                        sectionView()
                            .padding(.leading, 17)
                    }
                }
                .toolbar(.hidden, for: .navigationBar)
            }
        }
        .task(priority: .high) {
            await clothes.fetchProducts()
        }
    }
    
    
    private func sectionView() -> some View {
        ScrollView(.vertical) {
            VStack(alignment: .leading) {
                ForEach(Product.ProductCategory.allCases, id: \.self) { category in
                    Section(header: Text(category.rawValue).titleSection()) {
                        if let productInCategories = clothes.groupedProducts[category.rawValue] {
                            if idiom == .pad {
                                customHGridForPad(products: productInCategories)
                            } else {
                                customHGridforPhone(products: productInCategories)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func customHGridForPad(products: [Product]) -> some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(products) { product in
                    VStack(alignment: .leading) {
                        ZStack(alignment: .bottomTrailing) {
                            ClothesImage(url: product.picture.url, width: 221, height: 254)
                            Likes(productId: product.id)
                                .frame(width: 51, height: 27)
                                .padding(.bottom, 11.83)
                                .padding(.trailing, 11.36)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityHidden(true)
                        .padding(.horizontal, 4)
                        DetailsProductDescription(product: product)
                            .padding(.horizontal, 4)
                            .accessibilityElement(children: .combine)
                            .accessibilityHidden(true)
                    }
                    .onTapGesture {
                        currentSelectedProduct = product
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(product.accessibilityLabel)
                }
            }
        }
    }
    
    private func customHGridforPhone(products: [Product]) -> some View {
        NavigationStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(products) { product in
                        NavigationLink(value: product, label: {
                            VStack(alignment: .leading) {
                                ZStack(alignment: .bottomTrailing) {
                                    ClothesImage(url: product.picture.url, width: 198, height: 198)
                                    Likes(productId: product.id)
                                        .frame(width: 51, height: 27)
                                        .padding(.bottom, 11.83)
                                        .padding(.trailing, 11.36)
                                }
                                .accessibilityElement(children: .combine)
                                .accessibilityHidden(true)
                                .padding(.horizontal, 4)
                                DetailsProductDescription(product: product)
                                    .padding(.horizontal, 4)
                            }
                        })
                        .accessibilityLabel(product.accessibilityLabel)
                    }
                }
            }
            .navigationDestination(for: Product.self) { product in
                ProductDetailsView(product: product, review: "")
            }
        }
    }

}

private func showProgressView() -> some View {
    VStack(alignment: .center) {
        ProgressView()
            .position(.zero)
    }
}

#Preview {
    CatalogView()
}
