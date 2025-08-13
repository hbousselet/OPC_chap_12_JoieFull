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
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: url)) { image in
            image
                .resizable()
                .scaledToFill()
                .clipped()
        } placeholder: {
            ProgressView()
        }
        .frame(width: width, height: height)
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}

struct ClothesViewBis: View {
    let url: String
    let width: CGFloat
    let height: CGFloat
        
    var body: some View {
        AsyncImage(
            url: URL(string: url),
            transaction: Transaction(animation: .easeInOut)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            case .failure(let error):
                if (error as? URLError)?.code == .cancelled {
                    ClothesViewBis(url: url, width: width, height: height)
                } else {
                    Image(systemName: "exclamationmark.triangle")
                        .frame(width: width, height: height)
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                }
            default:
                Image(systemName: "photo")
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }
        }
    }
}

struct DetailsProductDescription: View {
    let product: Product
    var displayDescription: Bool = false
    @State var coucou: String = ""
    
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
                    .font(.system(size: displayDescription ? 18 : 14, weight: .semibold))
                    .foregroundStyle(.black)
                Spacer()
                HStack() {
                    Image(systemName: "star.fill")
                        .foregroundStyle(.orange)
                    Text("\(Double.random(in: 1...5), specifier: "%.1f")")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.black)
                }
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
            .font(.system(size: displayDescription ? 18: 14, weight: .regular))
            .padding(.top, displayDescription ? 1 : 0)
            if displayDescription {
                Text(product.picture.description)
                    .foregroundStyle(.black)
                    .font(.system(size: 14, weight: .regular))
                    .padding(.top, displayDescription ? 1 : 0)
            }
        }
        .padding(.horizontal, displayDescription ? 16 : 10)
    }
}

struct Likes: View {
    let likes = 5
    var body: some View {
        Capsule()
            .fill(.white)
            .overlay(
                HStack(alignment: .center) {
                    Image(systemName: "heart")
                        .font(.system(size: 14, weight: .semibold))
                    Text(likes.description)
                }
                    .foregroundStyle(.black)
            )
            .frame(width: 49.11, height: 26.84)
    }
}

#Preview {
    DetailsProductDescription(product: Product(id: 1,
                                                        picture: Product.Picture(url: "https://raw.githubusercontent.com/OpenClassrooms-Student-Center/Cr-ez-une-interface-dynamique-et-accessible-avec-SwiftUI/main/img/shoes/1.jpg", description: "Modèle femme qui pose dans la rue en bottes de pluie noires"),
                                                        name: "Sac à main orange",
                                                        category: Product.ProductCategory.accessories,
                                                        likes: Int(2.6),
                                                        price: 69.0,
                                                        originalPrice: 80.0),
                              displayDescription: true)
}
