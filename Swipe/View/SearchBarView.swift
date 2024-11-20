//
//  SearchBarView.swift
//  Swipe
//
//  Created by Nafeez Ahmed on 12/11/24.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String

    var body: some View {
            VStack {
                HStack {
                    Text("Swipe YC'21")
                        .font(.customTitleFont(size: 25))
                        .foregroundColor(.white)
                }
                HStack {
                    TextField("Search...", text: $text)
                        .padding(7)
                        .padding(.horizontal, 25)
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(20)
                        .overlay(
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 8)

                                if !text.isEmpty {
                                    Button(action: {
                                        text = ""
                                    }) {
                                        Image(systemName: "multiply.circle.fill")
                                            .foregroundColor(.gray)
                                            .padding(.trailing, 8)
                                    }
                                }
                            }
                        )
                        .padding(.horizontal, 10)
                    
                    NavigationLink(destination: AddView(viewModel: SwipeVM()), label: {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.white.opacity(0.1))
                            .cornerRadius(15)
                    })
                }
                .padding(.vertical, 10)
            }

        
        .background(Color.customBlack)
    }
}


#Preview {
    SearchBarView(text: .constant("Hey"))
}
