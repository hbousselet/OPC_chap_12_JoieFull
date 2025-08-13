//
//  ProductDetailsView.swift
//  OPC_chap_12_JoieFull
//
//  Created by Hugues BOUSSELET on 25/07/2025.
//

import SwiftUI

struct ProductDetailsView: View {
    @Environment(ClothesViewModel.self) private var clothes
    var product: Product
    let width = {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIScreen.main.bounds.width * 0.36
        } else {
            return UIScreen.main.bounds.width
        }
    }
    
    @State var review: String
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ZStack(alignment: .topTrailing) {
                    ZStack(alignment: .bottomTrailing) {
                        ClothesImage(url: product.picture.url,
                                       width: width() - 32,
                                       height: (1.2 * width()) - 32)
                        Likes(productId: product.id)
                            .padding(.bottom, 11.83)
                            .padding(.trailing, 11.36)
                    }
                    share()
                        .zIndex(1)
                        .foregroundStyle(.white)
                        .padding(.top, 10)
                        .padding(.trailing, 11.36)
                }
                .padding(.horizontal, 16)
                DetailsProductDescription(product: product, displayDescription: true)
                    .padding(.top, 8)
            }
        }
    }
    
    private func share() -> some View {
        Image(systemName: "square.and.arrow.up")
    }
    
    private func ratings() -> some View {
        
        HStack {
            
        }
    }
}

#Preview {
    ProductDetailsView(product: Product(id: 0,
                                                 picture: Product.Picture(url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/accessories/1.jpg", description: "Sac à main orange posé sur une poignée de porte"),
                                                 name: "Sac à main orange",
                                                 category: Product.ProductCategory.accessories,
                                                 likes: 56,
                                                 price: 69.99,
                                        originalPrice: 69.99, isLiked: false), review: "")
}
