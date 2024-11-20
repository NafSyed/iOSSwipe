//
//  IntroView.swift
//  Swipe
//
//  Created by Nafeez Ahmed on 20/11/24.
//

import SwiftUI

struct IntroView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.customBlack
                    .edgesIgnoringSafeArea(.all) // Ensure the color covers the entire screen
                
                VStack {
                    Spacer()
                    Text("Swipe YC'S21")
                        .font(.customFont(size: 53))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    Text("iOS Assignment")
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    NavigationLink(destination: ProductListView(), label: {
                        VStack {
                            Text("Continue")
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 25.0)
                                .fill(.white)
                        }
                    })
                    .padding(.bottom, 64)
                }
            }
        }
    }
}


#Preview {
    IntroView()
}
