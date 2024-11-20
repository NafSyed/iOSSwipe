//
//  ProductListView.swift
//  Swipe
//
//  Created by Nafeez Ahmed on 12/11/24.
//

import SwiftUI
import CoreData

struct ProductListView: View {
    @StateObject var viewModel = SwipeVM()
    @StateObject private var networkMonitor = NetworkMonitor()
    let cardColors: [Color] = [
        Color.Purple, Color.Green, Color.Red, Color.Yellow, Color.DarkGreen
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(text: $viewModel.searchQuery)
                    .padding(.horizontal)
                RivePullToRefreshView {
                    ScrollView {
                        if networkMonitor.isConnected {
                            VStack(spacing: 15) {
                                ForEach(0..<viewModel.filteredProducts.count, id: \.self) { index in
                                    createProductRow(index: index)
                                }
                            }
                            .padding()
                            
                        } else if let url = Bundle.main.url(forResource: "no-network", withExtension: "json") {
                            LottieView(url: url)
                        }
                    }
                    .task {
                        await fetchProducts()
                    }
                } onRefresh: {
                    await refreshProducts()
                }
            }
            .background(Color.customBlack)
        }
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    private func createProductRow(index: Int) -> some View {
        let product = viewModel.filteredProducts[index]
        let color = cardColors[index % cardColors.count]

        if index % 3 == 2 {
            FullWidthProductCardView(product: product, isFavorite: viewModel.favoriteProductNames.contains(product.product_name), isFavoriteToggle:{ viewModel.toggleFavorite(product)})
                .frame(maxWidth: .infinity)
        } else if index % 3 == 0 {
            HStack(spacing: 10) {
                ProductCardView(
                    product: product,
                    color: color,
                    isFavorite: viewModel.favoriteProductNames.contains(product.product_name),
                    isFavoriteToggle: {
                        viewModel.toggleFavorite(product)
                    }
                )
                .frame(maxWidth: .infinity)

                
                if index + 1 < viewModel.filteredProducts.count {
                    let nextProduct = viewModel.filteredProducts[index + 1]
                    let nextColor = cardColors[(index + 1) % cardColors.count]
                    ProductCardView(
                        product: nextProduct,
                        color: nextColor,
                        isFavorite: viewModel.favoriteProductNames.contains(nextProduct.product_name),
                        isFavoriteToggle: {
                            viewModel.toggleFavorite(nextProduct)
                        }
                    )
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }

    
    private func fetchProducts() async {
        do {
            viewModel.SwipeProducts = try await viewModel.getSwipeData()
        } catch {
            print("Failed to fetch products:", error)
        }
    }
    private func refreshProducts() async {
        do {
                    try await Task.sleep(nanoseconds: 3_000_000_000)
                    await viewModel.refreshData()
                    if networkMonitor.isConnected {
                        await fetchProducts()
                    }
                } catch {
                    print("Error while refreshing:", error)
                }
    }
}





struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView()
    }
}

