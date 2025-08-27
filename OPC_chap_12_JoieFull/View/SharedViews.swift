//
//  SharedViews.swift
//  OPC_chap_12_JoieFull
//
//  Created by Hugues BOUSSELET on 28/07/2025.
//

import Foundation
import SwiftUI

struct ClothesImage: View {
    let url: String
    
    var body: some View {
        AsyncImage(
            url: URL(string: url),
            transaction: Transaction(animation: .easeInOut)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .transition(.scale(scale: 0.1, anchor: .center))
                case .failure(let error):
                    Image(systemName: "wifi.slash")
                default:
                    Image("bag")
                }
            }
    }
}

struct DetailsProductDescription: View {
    let product: Product
    var displayDescription: Bool = false
    
    var productName: String {
        if product.name.count > 15 && displayDescription == false {
            return "\(String(product.name.prefix(10)))..."
        } else {
            return product.name
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text(productName)
                    .font(.custom("SFProDisplay", size: displayDescription ? 18 : 14))
                    .foregroundStyle(.black)
                Spacer()
                HStack() {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.orange)
                    Text("\(product.evaluation, specifier: "%.1f")")
                        .foregroundStyle(.black)
                }
//                .font(.system(size: 14, weight: .regular))
                .font(.custom("SFProDisplay", size: 14))
                .scaledToFit()
                .font(.caption)
                .minimumScaleFactor(0.2)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Rating: \(Double.random(in: 1...5), specifier: "%.1f")")
            }
            HStack(alignment: .center) {
                Text("\(product.price, specifier: "%.2f") €")
                    .foregroundStyle(.black)
                Spacer()
                Text("\(product.originalPrice, specifier: "%.2f")€")
                    .foregroundStyle(.black)
                    .strikethrough()
                    .accessibilityLabel("Ancien prix: \(product.originalPrice, specifier: "%.2f")€")
            }
            .font(.custom("SFProDisplay", size: displayDescription ? 18 : 14))
            .scaledToFill()
            .font(.headline)
            .minimumScaleFactor(0.5)
//            .font(.system(size: displayDescription ? 18: 14, weight: .regular))
            .padding(.top, displayDescription ? 1 : 0)
            if displayDescription {
                Text(product.picture.description)
                    .foregroundStyle(.black)
                    .font(.custom("SFProDisplay", size: 14))
                    .scaledToFill()
                    .font(.headline)
                    .minimumScaleFactor(0.5)
                    .padding(.top, displayDescription ? 1 : 0)
            }
        }
        .padding(.horizontal, displayDescription ? 16 : 10)
    }
}

struct Likes: View {
    @Environment(ClothesViewModel.self) private var clothes
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    @ScaledMetric(relativeTo: .body) private var likeFrameWidth: CGFloat = 51
    @ScaledMetric(relativeTo: .body) private var likeFrameHeight: CGFloat = 27

    let productId: Int
    
    var product: Product? {
        clothes.products.first(where: { $0.id == productId })
    }
    
    var body: some View {
        if let product {
            ZStack {
                Capsule()
                    .fill(.white)
                    .frame(width: likeFrameWidth, height: likeFrameHeight)
                    .font(.body)
                HStack(alignment: .center) {
                    Image(systemName: product.isLiked ? "heart.fill" : "heart")
                    Text(product.likes.description)
                }
                .font(.custom("SFProDisplay", size: 14))
                .padding(.vertical, 4)
                .foregroundStyle(.black)
            }
                .onTapGesture {
                clothes.toggleIsLiked(for: product)
                    if product.isLiked {
                        clothes.removeLike(for: product)
                    } else {
                        clothes.addLike(for: product)
                    }
            }
        } else {
            Text("Not able to find the product")
        }
    }
}

struct Profile: View {
    var body: some View {
        Image("Charlie")
            .resizable()
            .scaledToFill()
            .clipShape(Circle())
            .background(.white)
            .frame(width: 43, height: 39)
    }
}

struct Evaluation: View {
    @State var rating: Int = -1
    
    var body: some View {
        HStack(alignment: .center) {
            ForEach(0..<5, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .foregroundStyle(index <= rating ? .yellow : .gray)
                    .frame(width: 28, height: 24)
                    .font(.system(size: 20))
                    .fixedSize(horizontal: true, vertical: true)
                    .onTapGesture {
                        rating = index
                    }
            }
        }
    }
}

struct Commentary: View {
    @State var comment: String = ""
    
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
            .stroke(lineWidth: 1)
            .foregroundStyle(.gray)
            .frame(height: 120)
            .overlay(alignment:.top) {
                TextField("Partagez ici vos impressions sur cette pièce", text: $comment)
                    .font(.system(size: 14, weight: .regular))
                    .padding(.top, 5)
                    .padding(.horizontal)
            }
    }
}

#Preview {
    DetailsProductDescription(product: Product(id: 1,
                                                        picture: Product.Picture(url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/shoes/1.jpg", description: "Modèle femme qui pose dans la rue en bottes de pluie noires"),
                                                        name: "Sac à main orange",
                                                        category: Product.ProductCategory.accessories,
                                                        likes: Int(2.6),
                                                        price: 69.0,
                                               originalPrice: 80.0, isLiked: false, evaluation: 5.0, accessibilityLabel: "Coucou"),
                              displayDescription: true)
}
