//
//  ProductDetailsView.swift
//  OPC_chap_12_JoieFull
//
//  Created by Hugues BOUSSELET on 25/07/2025.
//

import SwiftUI

struct ProductDetailsView: View {
    @Environment(ClothesViewModel.self) private var clothes
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    var product: Product
    
    @State var needImageInFullScreen: Bool = false
    @GestureState private var zoom = 1.0
    
    @ScaledMetric private var bottomPadding: CGFloat = 14
    @ScaledMetric private var trailingPadding: CGFloat = 17
    
    @ScaledMetric private var shareViewWidth: CGFloat = 18
    @ScaledMetric private var shareViewHeight: CGFloat = 18
    
    var body: some View {
        ScrollView {
            GeometryReader { geometry in
                VStack(alignment: .leading) {
                    ZStack(alignment: .topTrailing) {
                        ZStack(alignment: .bottomTrailing) {
                            ClothesImage(url: product.picture.url)
                                .frame(width: geometry.size.width - 32, height: (1.2 * geometry.size.width) - 32)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                            Likes(productId: product.id)
                                .padding(.bottom, bottomPadding)
                                .padding(.trailing, trailingPadding)
                                .accessibilityHidden(true)
                            
                        }
                        ShareLink(item: URL(string: product.picture.url)!,
                                  subject: Text("Partager le produit avec vos amis"),
                                  message: Text("Partager l'image du produit avec vos amis: ")) {
                            Image("Partager")
                                .accessibilityHidden(true)
                        }
                                  .frame(width: shareViewWidth, height: shareViewHeight)
                                  .zIndex(1)
                                  .foregroundStyle(.white)
                                  .padding(.top, 20)
                                  .padding(.trailing, 17)
                        
                    }
                    .padding(.horizontal, 16)
                    DetailsProductDescription(product: product, displayDescription: true)
                        .padding(.top, 8)
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel(product.accessibilityLabel)
                    HStack(alignment: .center) {
                        Profile()
                        Evaluation()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 5)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Evaluer le produit")
                    Commentary()
                        .padding(.horizontal, 16)
                        .padding(.top, 5)
                        .accessibilityLabel("Commenter le produit")
                    
                }
            }
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
                                        originalPrice: 69.99, isLiked: false, evaluation: 2.3, accessibilityLabel: "Coucou"))
}
