//
//  FullWidthProductCardView.swift
//  Swipe
//
//  Created by Nafeez Ahmed on 13/11/24.
//

import SwiftUI

struct FullWidthProductCardView: View {
    let product: SwipeModel
    var isFavorite: Bool
    var isFavoriteToggle: () -> Void
    var body: some View {
        VStack {
            HStack {
                Text(product.product_type)
                    .font(.customFont(size: 16))
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {isFavoriteToggle()}, label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                })
                
            }
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15.0)
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
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text("Price: $\(product.price, specifier: "%.f")")
                        .font(.subheadline)
                    
                    Text("Tax: $\(product.tax, specifier: "%.f")")
                        .font(.subheadline)
                }
                .foregroundColor(.white)
            }
        }
        .padding()
        .frame(width: 350, height: 200)
        .background(RoundedRectangle(cornerRadius: 15).fill(Color("Purple")).shadow(radius: 5))
    }
}

#Preview {
    FullWidthProductCardView(product: SwipeModel(image: "", price: 0.0, product_name: "Apple iPhone", product_type: "Electronics", tax: 0.0), isFavorite: false, isFavoriteToggle: {})
}
