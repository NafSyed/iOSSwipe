//
//  ProductCardView.swift
//  Swipe
//
//  Created by Nafeez Ahmed on 12/11/24.
//

import SwiftUI
import Lottie

struct ProductCardView: View {
    let product: SwipeModel
    let color: Color
    var isFavorite: Bool
    var isFavoriteToggle: () -> Void

    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text(product.product_type)
                    .fontWeight(.bold)
                    .font(.customFont(size: 16))
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(.red)
                    .onTapGesture {
                        isFavoriteToggle()
                    }
            }
            .padding()
            ZStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundColor(.white.opacity(0.1))
                    .frame(width: 150, height: 150)
                if let imageUrl = product.image, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        phase.image?
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    }
                } else if let url = Bundle.main.url(forResource: "img-placeholder", withExtension: "json") {
                    LottieView(url: url)
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        
                }
            }
            VStack {
                Text(product.product_name)
                    .font(.subheadline)
                    .fontWeight(.bold)
                Text("Price: $\(product.price, specifier: "%.f")")
                    .font(.subheadline)
                Text("Tax: $\(product.tax, specifier: "%.f")")
                    .font(.subheadline)
            }
            .foregroundColor(.white)
            .fontWeight(.semibold)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(color).shadow(radius: 5))
    }
}


#Preview {
    ProductCardView(product: SwipeModel(image: "placeholder", price: 0.0, product_name: "Hair Conditioner", product_type: "Soaps and Shampoos", tax: 0.0), color: .white, isFavorite: false, isFavoriteToggle: {})
}
