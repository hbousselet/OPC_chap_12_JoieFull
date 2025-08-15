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
    
    @State var needImageInFullScreen: Bool = false
    @GestureState private var zoom = 1.0
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    ZStack(alignment: .topTrailing) {
                        ZStack(alignment: .bottomTrailing) {
                            ClothesImage(url: product.picture.url,
                                         width: width() - 32,
                                         height: (1.2 * width()) - 32)
                            .scaleEffect(needImageInFullScreen ? zoom : 1)
                            .gesture(
                                MagnifyGesture()
                                    .updating($zoom) { value, gestureState, transaction in
                                        gestureState = value.magnification
                                    }
                            )
                            .onTapGesture {
                                withAnimation(.spring(duration: 0.5)) {
                                    needImageInFullScreen.toggle()
                                }
                            }
                            if needImageInFullScreen == false {
                                Likes(productId: product.id)
                                    .padding(.bottom, 11.83)
                                    .padding(.trailing, 11.36)
                                    .accessibilityHidden(true)
                            }
                        }
                        if needImageInFullScreen == false {
                            ShareLink(item: URL(string: product.picture.url)!,
                                      subject: Text("Share the product with your friends"),
                                      message: Text("Share the following product with your friends: ")) {
                                Image(systemName: "square.and.arrow.up")
                                    .accessibilityHidden(true)
                            }
                                .zIndex(1)
                                .foregroundStyle(.white)
                                .padding(.top, 10)
                                .padding(.trailing, 11.36)
                        }
                    }
                    .padding(.horizontal, 16)
                    if needImageInFullScreen == false {
                        DetailsProductDescription(product: product, displayDescription: true)
                            .padding(.top, 8)
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel(product.accessibilityLabel)
                        HStack(alignment: .center) {
                            Profile()
                                .frame(width: 43, height: 39)
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
    
    let width = {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UIScreen.main.bounds.width * 0.36
        } else {
            return UIScreen.main.bounds.width
        }
    }
    
    @State var review: String
    
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
                                        originalPrice: 69.99, isLiked: false, evaluation: 2.3, accessibilityLabel: "Coucou"), review: "")
}
